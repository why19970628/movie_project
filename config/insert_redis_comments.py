## 弹幕推送 demo

#列表类型list
import redis,json,datetime,uuid,random
# 连接数据库

client = redis.StrictRedis(host='localhost', port=6379, db=0)
fr=open("qinghua.txt","r",encoding="utf-8")
colors=["#fff","#64DD17","#ffe133","#D500F9","#e54256","#39ccff"]
pos=["right", "top","bottom"]
ips=fr.readlines()
for line in ips:
    print(line)
    color = random.choice(colors)
    pos = random.choice(pos)
    time=random.randint(1,55)
    msg = {
        "__v": 0,
        "author": "DIYgod",
        "time": time,
        "text": line,
        "color": color,
        "type": "right", ## right top bottom
        "ip": "127.0.0.1",
        "_id": datetime.datetime.now().strftime("%Y%m%d%H%M%S") + uuid.uuid4().hex,
        "player": ["30"]
    }
    res = {
        "code": 1,
        "data": msg
    }
    resp = json.dumps(res)
    # 将添加的弹幕推入redis的队列中
    print(json.dumps(msg))
    client.lpush("movie39", json.dumps(msg))