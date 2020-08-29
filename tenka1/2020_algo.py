#!/usr/bin/env python3
#coding:utf-8

import os
import random
import time
from typing import List, Tuple
from urllib.request import urlopen
import json

GAME_SERVER = os.getenv('GAME_SERVER', 'https://contest.gbc-2020.tenka1.klab.jp')
TOKEN = os.getenv('TOKEN', '')

def call_api(x) -> str:
	with urlopen(f'{GAME_SERVER}{x}') as res:
		return res.read().decode()

def calc_score(stage: List[List[int]], num_claim: List[List[int]], my_claim: List[List[int]]) -> float:
	visited = [[False for _ in range(20)] for _ in range(20)]

	def f(r, c) -> Tuple[float, int]:
		if r < 0 or r >= 20 or c < 0 or c >= 20 or my_claim[r][c] == 0 or visited[r][c]:
			return 1e+300, 0
		visited[r][c] = True
		r1 = stage[r][c] / num_claim[r][c]
		r2 = 1
		for r3, r4 in (f(r+1, c), f(r-1, c), f(r, c+1), f(r, c-1)):
			r1 = min(r1, r3)
			r2 += r4
		return r1, r2

	score = 0.0
	for i in range(20):
		for j in range(20):
			x, y = f(i, j)
			score += x * y
	return score

def claim(game_id,r,c,size):
	#print(r,c,size)
	while True:
		claim_resp = call_api(f'/api/claim/{TOKEN}/{game_id}/{r}-{c}-{size}').split('\n')[0]
		print(claim_resp)
		if claim_resp == 'game_finished':
			return False
		if claim_resp == 'ok':
			return True
		time.sleep(0.2)

R=20
C=20
def main():
	while True:
		game_resp = call_api('/api/game')
		game_id, remaining_ms = list(map(int, game_resp.split()))

		if game_id < 0:
			break

		stage_resp = call_api(f'/api/stage/{game_id}').split('\n')
		assert stage_resp[0] == '20'
		stage = [list(map(int, x.split(' '))) for x in stage_resp[1:21]]
		#for e in stage: print(e)

		# get largest rectangle
		#claim(game_id,0,0,20)

		iter = 0
		all_get_list = []
		while True:
			iter+=1
			areas_resp = call_api(f'/api/areas/{TOKEN}/{game_id}').split('\n')
			if areas_resp[0] == 'too_many_request':
				time.sleep(0.5)
				continue
			assert areas_resp[0] == 'ok'
			num_claim = [list(map(int, x.split(' '))) for x in areas_resp[1:21]]
			my_claim = [list(map(int, x.split(' '))) for x in areas_resp[21:41]]

			score = calc_score(stage, num_claim, my_claim)
			print(f'game_id: {game_id}  score: {score}')

			def is_claimed(y,x):
				for (dy,dx) in [(0,0),(0,-1),(-1,0),(0,1),(1,0)]:
					if 0<=y+dy<R and 0<=x+dx<C and my_claim[y+dy][x+dx]:
						return True
				return False

			# num_claimを怖がるよりも多少はマスの価値を優先したほうが良いから
			num_factor = 0.1
			values = json.loads(json.dumps(stage))
			for i in range(R):
				for j in range(C):
					if my_claim[i][j]:
						values[i][j] = 0
					elif is_claimed(i,j):
						values[i][j] = -1
					else:
						values[i][j] = values[i][j]*1.0/( (num_claim[i][j]*num_factor + 1) )
			#for e in values: print([int(x) for x in e])

			# 同じ合計価値ならサイズが小さい領域の方がいいでしょ(と思ったけど逆にスコアが落ちるようだった)
			size_factor = 1
			lst = []
			min_size = 1 #5 if iter<6 else 1
			for size in range(min_size,6):
				for i in range(R-size+1):
					for j in range(C-size+1):
						v = 10**9
						for i2 in range(size):
							for j2 in range(size):
								v = min(v,values[i+i2][j+j2])
						lst.append((i,j,size,v*num_factor*size**2,v*num_factor*(size*size_factor)**2))
			num = 1
			#if iter>=20: num=5
			lst = [e for e in sorted(lst,key=lambda e:-e[-1]) if tuple(e[:-1]) not in all_get_list][:num]
			#print(lst)
			if lst[0][-1] == 0:
				# no other rects should be claimed.
				break

			for (i,j,size,real_score,comp_score) in lst:
				all_get_list.append((i,j,size))
				print(i,j,size,real_score,comp_score)
				if not claim(game_id,i,j,size): break
			else:
				continue
			# game_finished
			break

		while int(call_api('/api/game').split()[0]) == game_id:
			time.sleep(0.5)

if __name__ == "__main__":
	main()
