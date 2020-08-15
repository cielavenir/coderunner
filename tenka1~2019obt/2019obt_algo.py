
#!/usr/bin/env python3
#coding:utf-8

import os
import random
from typing import NamedTuple, List, Dict
from urllib.request import urlopen
import time

# ゲームサーバのアドレス
GAME_SERVER = os.getenv('GAME_SERVER', 'https://obt.tenka1.klab.jp')

# あなたのトークン
TOKEN = os.getenv('TOKEN', '')

# 頂点と辺の数
NUM_NODES = 400
NUM_EDGES = 760

def f(n,d):
	# なんかパニクったので　上下左右の辺を返す関数を作った
	y=n//20
	x=n%20
	if d=='L':
		return y*39 + x - 1
	if d=='R':
		return y*39 + x
	if d=='U':
		return y*39 + x - 19 - 1
	if d=='D':
		return y*39 + x + 19

def connect(source,sink,caps):
	# 最短経路よりは幅優先とかで最小値最大化をすべきだったけど面倒だったんで
	ret = []
	cost = 99999999
	while source//20 != sink//20:
		if source<sink:
			elem = f(source,'D')
			#cost += caps[elem]
			cost = min(cost,caps[elem])
			ret.append( elem )
			source += 20
		elif source>sink:
			elem = f(source,'U')
			#cost += caps[elem]
			cost = min(cost,caps[elem])
			ret.append( elem )
			source -= 20
	while source%20 != sink%20:
		if source<sink:
			elem = f(source,'R')
			#cost += caps[elem]
			cost = min(cost,caps[elem])
			ret.append( elem )
			source += 1
		elif source>sink:
			elem = f(source,'L')
			#cost += caps[elem]
			cost = min(cost,caps[elem])
			ret.append( elem )
			source -= 1
	return ret,cost

def call_api(x):
	with urlopen(f'{GAME_SERVER}{x}') as res:
		return res.read().decode()

def claim(game_id,edge_index):
	# GET /api/claim/<token>/<game_id>/<edge_index>
	claim_resp = call_api(f'/api/claim/{TOKEN}/{game_id}/{edge_index}').strip()
	print(claim_resp)
	if claim_resp == "ok":
		print(f"辺取得成功 {edge_index}")
		return True
	elif claim_resp == "game_finished":
		return None
	else:
		print(f"辺取得失敗 {edge_index}")
		return True

def main():
	while True:
		# GET /api/game
		game = call_api('/api/game')
		game_id, remaining_ms = list(map(int, game.split()))
		print(f"ゲームID {game_id}")
		print(f"残り時間 {remaining_ms}ms")

		if game_id < 0:
			break

		# GET /api/stage/<game_id>
		stage_resp = call_api(f'/api/stage/{game_id}')
		stage = list(map(int, stage_resp.split()))

		num_source = stage[0]
		num_sink = stage[1]
		sources = stage[2:2 + num_source]
		sinks = stage[2 + num_source:2 + num_source + num_sink]
		caps = stage[2 + num_source + num_sink:]
		assert len(caps) == NUM_EDGES

		maxcost = 0 #9999999
		for source in sources:
			for sink in sinks:
				connection,cost = connect(source,sink,caps)
				if cost > maxcost:
					maxconnection = connection
					maxcost = cost
		print(maxcost)

		while maxconnection and 0 < remaining_ms:
			game = call_api('/api/game')
			game_id, remaining_ms = list(map(int, game.split()))
			edge_index = maxconnection.pop(0)
			ret = claim(game_id,edge_index)
			if ret is None:
				break
			time.sleep(0.5)

		while True:
			print(f"残り時間 {remaining_ms}ms")
			game = call_api('/api/game')
			_game_id, remaining_ms = list(map(int, game.split()))
			if _game_id != game_id: break
			game_id = _game_id
			if remaining_ms <= 0: break
			edge_index = random.randint(0, NUM_EDGES - 1)
			#ret = claim(game_id,edge_index)
			#if ret is None:
			#	break

			# 辺の取得状況を確認し、スコアを計算します
			# GET /api/edges/<token>/<game_id>
			edges_resp = call_api(f'/api/edges/{TOKEN}/{game_id}').strip().split('\n')
			if edges_resp[0] == "ok":
				claim_counts = list(map(int, edges_resp[1].split()))
				my_claims = list(map(int, edges_resp[2].split()))
				score = calculate_score(sources, sinks, caps, claim_counts, my_claims)
				print("スコア", score)

			# API制限のため少しの間待ちます
			time.sleep(0.5)


# cf. https://github.com/spaghetti-source/algorithm/blob/9cca6b826f19ed7e42dd326a4fbbb9f4d34f04d3/graph/maximum_flow_dinic.cc
INF = 1 << 50


class Edge(NamedTuple):
	src: int
	dst: int
	capacity: int
	rev: int


class Graph:
	def __init__(self, n: int):
		self.n = n
		self.adj: List[List[Edge]] = [[] for _ in range(n)]
		self.flow: Dict[Edge, int] = {}

	def add_edge(self, src: int, dst: int, capacity: int):
		e1 = Edge(src, dst, capacity, len(self.adj[dst]))
		self.adj[src].append(e1)
		self.flow[e1] = 0
		e2 = Edge(dst, src, 0, len(self.adj[src])-1)
		self.adj[dst].append(e2)
		self.flow[e2] = 0

	def max_flow(self, s: int, t: int):
		level = [0 for _ in range(self.n)]
		iter = [0 for _ in range(self.n)]

		def levelize():
			for i in range(len(level)):
				level[i] = -1
			level[s] = 0
			q = [s]
			while q:
				u, q = q[0], q[1:]
				if u == t:
					break
				for e in self.adj[u]:
					if e.capacity > self.flow[e] and level[e.dst] < 0:
						q.append(e.dst)
						level[e.dst] = level[u] + 1
			return level[t]

		def augment(u, cur):
			if u == t: return cur
			while iter[u] < len(self.adj[u]):
				e = self.adj[u][iter[u]]
				r = self.adj[e.dst][e.rev]
				if e.capacity > self.flow[e] and level[u] < level[e.dst]:
					f = augment(e.dst, min(cur, e.capacity - self.flow[e]))
					if f > 0:
						self.flow[e] += f
						self.flow[r] -= f
						return f
				iter[u] += 1
			return 0

		flow = 0
		while levelize() >= 0:
			iter = [0 for _ in range(self.n)]
			while True:
				f = augment(s, INF)
				if f <= 0:
					break
				flow += f
		return flow


# フローを流して点数を計算します
def calculate_score(sources, sinks, caps, claim_counts, my_claims):
	ratio = 1000

	g = Graph(NUM_NODES + 2)

	# 各始点に向けて容量無限の辺を貼る
	for source_node in sources:
		g.add_edge(NUM_NODES, source_node, INF)

	# 各終点から容量無限の辺を貼る
	for sink_node in sinks:
		g.add_edge(sink_node, NUM_NODES + 1, INF)

	# 自分が取得した辺を貼る
	for edge_index in range(NUM_EDGES):
		if not my_claims[edge_index]:
			continue
		q = edge_index // 39
		r = edge_index % 39
		if r < 19:
			v1 = 20 * q + r
			v2 = 20 * q + r + 1
		else:
			v1 = 20 * q + r - 19
			v2 = 20 * q + r - 19 + 20
		cap = caps[edge_index] * ratio // claim_counts[edge_index]
		g.add_edge(v1, v2, cap)
		g.add_edge(v2, v1, cap)

	return g.max_flow(NUM_NODES, NUM_NODES + 1) / ratio


if __name__ == "__main__":
	while True:
		try:
			main()
		except Exception as e:
			print(repr(e))
			pass
