#!/usr/bin/env python
import aiohttp
from loguru import logger
from lib.score import score
import numpy as np
import asyncio
from retrying import retry
from io import BytesIO
from lib.min_max import MIN, MAX_MIN
from xsmpy import run
from os import getenv
import psycopg
from psycopg.sql import SQL
import pillow_avif  # noqa
from PIL import Image
# from redis.asyncio import StrictRedis

# KV_HOST, KV_PORT = getenv('KV_HOST_PORT').split(':')
#
# KV = StrictRedis(host=KV_HOST,
#                  port=int(KV_PORT),
#                  password=getenv('KV_PASSWORD'))

CONN = None


async def conn():
  global CONN
  CONN = await psycopg.AsyncConnection.connect('postgresql://' +
                                               getenv('APG_URI'),
                                               autocommit=True)


asyncio.run(conn())

POWER = np.array((0.128991374450439, 0.394689166910878, 0.476319458638683))

URL = 'https://5ok.pw/h952/'


def normalize_score(img):
  li = np.array(score(img))
  return np.dot((li - MIN) / MAX_MIN, POWER)


@retry(stop_max_attempt_number=9)
async def fetch(url):
  async with aiohttp.ClientSession() as session:
    async with session.get(url) as response:
      return await response.read()


async def _iaa(id):
  r = await (await CONN.execute(
      SQL('SELECT hash FROM bot.task WHERE id={}').format(id))).fetchone()
  if not r:
    print(f"task {id} not exist")
    return
  hash, = r
  url = URL + hash

  bin = BytesIO(await fetch(url))
  img = Image.open(bin)
  img = img.convert('RGB')
  bin = BytesIO()
  img.save(bin, 'PNG', compress_level=0)
  s = min(127, max(0, round(100 * normalize_score(bin.getvalue()))))

  print(id, s)
  await CONN.execute(
      SQL('UPDATE bot.task SET iaa={} WHERE id={}').format(s, id))

  if s > 25:
    return 'clip', id
  else:
    print('iaa=%d' % s, id, url)


async def iaa(id):
  n = 0
  while 1:
    try:
      return await _iaa(id)
    except psycopg.OperationalError as err:
      await asyncio.sleep(1)
      n += 1
      if n < 6:
        logger.exception(err)
        await conn()
        continue
      raise err


run('iaa', iaa)
