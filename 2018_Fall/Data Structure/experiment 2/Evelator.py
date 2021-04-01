# coding=utf-8
import threading
import Tkinter as tk
import time
import random
import tkMessageBox as mb

# import tx
window=tk.Tk()
window.title('Evelator')
window.geometry('1500x800')

canvas=tk.Canvas(window,height=750,width=1350)
canvas.place(x=0,y=0)
image_file=tk.PhotoImage(file='chopper.gif')
#image=[canvas.create_image(85,60,anchor='center',image=image_file)]

# 静态部件，分割线，楼层显示等
for i in range(4):
    canvas.create_line(10,10+240*i,1340,240*i+10)
canvas.create_line(10,10,10,730,fill='yellow')
canvas.create_line(180,10,180,730,fill='yellow')
canvas.create_line(650,10,650,730,fill='dark blue')
canvas.create_line(670,10,670,730,fill='yellow')
canvas.create_line(840,10,840,730,fill='yellow')
canvas.create_line(1300,10,1300,730,fill='dark blue')
for a in range(2):
    for b in range(3):
        canvas.create_polygon((185+a*660,160+b*240,195+a*660,160+b*240,190+a*660,150+b*240),fill='grey')
        canvas.create_polygon((185+a*660,170+b*240,195+a*660,170+b*240,190+a*660,180+b*240),fill='grey')
tk.Label(window,text='5F',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=190,y=30)
tk.Label(window,text='4F',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=190,y=270)
tk.Label(window,text='3F',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=190,y=510)
tk.Label(window,text='2F',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=850,y=30)
tk.Label(window,text='1F',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=850,y=270)
tk.Label(window,text='B1',font=('MS Gothic',16),fg='orange',bg='purple',width=3,height=1).place(x=850,y=510)
canvas.create_line(1300,10,1300,730,fill='blue')

# 动态部件，电梯，电梯门等
rect=canvas.create_rectangle(670,530,840,730)
line1=canvas.create_line(755,530,755,730)
line2=canvas.create_line(755,530,755,730)

class elevator:
    people=0   # 是否载人
    floor=0     # 在几层
    up=0        # 是否上升
    down=0      # 是否下降
    stop=0      # 是否停下
    open_door=0 # 是否正在开门
    close_door=0    # 是否正在关门
    door=0      # 门的状态是开是关
    time=0
    def __init__(self):
        self.stop=1
        self.up=1
        
dict={1:250,0:910}
def move0(image,x):
    for i in range(x/5):
        canvas.move(image,-5,0)
        time.sleep(0.001)
        
class people:
    x=0
    want=0
    image=0
    time=0
    def __init__(self,x,b,c):
        self.x=x
        self.want=c
        self.time=0
        self.image=canvas.create_image(dict[b/3]+300,660-(b%3)*240,anchor='center',image=image_file)
        th=threading.Thread(target=move0,args=(self.image,dict[b/3]+300-x,))
        th.setDaemon(True)
        th.start()
        
# image=[people(910,3,6)]
def move_dt(flag,image):
    if flag==0:return
    f=4*flag
    canvas.move(rect,0,f)
    canvas.move(line1,0,f)
    canvas.move(line2,0,f)
    if image!=[]:
        l=len(image)
        for j in range(l):
            canvas.move(image[j].image,0,f)
    canvas.update()
    time.sleep(0.01)

def move_big(flag,image):    
    canvas.move(rect,flag*660,-720*flag)
    canvas.move(line1,flag*660,-720*flag)
    canvas.move(line2,flag*660,-720*flag)
    if image!=[]:
        l=len(image)
        for j in range(l):
            canvas.move(image[j].image,660*flag,-720*flag)
        
def open_door():
    canvas.move(line1,-5,0)
    canvas.move(line2,+5,0)
    canvas.update()
        
def move_in(image):
    for i in range(50):
        canvas.move(image,-3.3,0)
        canvas.update()
        time.sleep(0.01)
        
def close_door():
    canvas.move(line1,5,0)
    canvas.move(line2,-5,0)
    canvas.update()
        
def move_out(image,x):
    for j in range(x/5):
        canvas.move(image,4,0)
        canvas.update()
        time.sleep(0.01)
    canvas.delete(image)
    
queue=[[],[],[],[],[],[]]
def prepare():
    n=int(var1.get())
    where=int(var2.get())-1
    want=int(var3.get())-1
    for i in range(n):
        x=len(queue[where])*8+dict[(where)/3]
        image0=people(x,where,want)
        queue[where].append(image0)
        a=1-where/3
        b=2-where%3
        if want>where:
            canvas.create_polygon((185+a*660,160+b*240,195+a*660,160+b*240,190+a*660,150+b*240),fill='red')
        else:
            canvas.create_polygon((185+a*660,170+b*240,195+a*660,170+b*240,190+a*660,180+b*240),fill='red')
        time.sleep(0.003)
qqq=1
def random0():
    global qqq
    print (qqq)
    qqq=qqq*(-1)
    
def prepare_random():
    n=random.randint(1,2)
    where=random.randint(0,5)  
    while (1):
        want=random.randint(0,5)
        if want!=where:break
    print (str(n)+'people from '+str(where+1)+' to '+str(want+1) )
    for i in range(n):
        x=len(queue[where])*8+dict[(where)/3]
        image0=people(x,where,want)
        queue[where].append(image0)
        a=1-where/3
        b=2-where%3
        if want>where:
            canvas.create_polygon((185+a*660,160+b*240,195+a*660,160+b*240,190+a*660,150+b*240),fill='red')
        else:
            canvas.create_polygon((185+a*660,170+b*240,195+a*660,170+b*240,190+a*660,180+b*240),fill='red')
        time.sleep(0.003)
var1=tk.StringVar()
entry=tk.Entry(window,textvariable=var1,font=('Arial',16),width=3,show=None).place(x=1350,y=250)
var2=tk.StringVar()
entry=tk.Entry(window,textvariable=var2,font=('Arial',16),width=3,show=None).place(x=1350,y=300)
var3=tk.StringVar()
entry=tk.Entry(window,textvariable=var3,font=('Arial',16),width=3,show=None).place(x=1350,y=350)
ele=elevator()
people0=[]
qq=0
time.sleep(0.1)
# ch1=tk.Button(window,text='join',command=prepare,width=8).place(x=1340,y=400)
t=0
time0=time.time()
while (1):
    time.sleep(0.005)
    #ch1=tk.Button(window,text='join',command=prepare,width=8).place(x=1320,y=400)
    #ch2=tk.Button(window,text='random',command=random0,width=8).place(x=1320,y=450)
    random0()
    if time.time()-time0>=random.randint(5,10) and qqq==-1:
        prepare_random()
        time0=time.time()
    window.update()
    for i in range(6):   # 忍耐时间
        l=len(queue[i])
        for j in range(l):
            try:
                queue[i][j].time+=1
            except:
                continue
            if queue[i][j].time>=500 and abs(queue[i][j].want-ele.floor)>1:
                time.sleep(0.15)
                th=threading.Thread(target=move_out,args=(queue[i][j].image,100,))
                th.setDaemon(True)
                th.start()
                time.sleep(0.15)
                del(queue[i][j])
    ele.time+=1
    if ele.door==0 and ele.floor==0 and queue==[[],[],[],[],[],[]] and people0==[]:
        ele.up=1
        ele.stop=1
        continue
    if ele.door==0 and ele.stop==1 and queue==[[],[],[],[],[],[]] and people0==[]:
        t=t+1
        if t%80==0:
            ele.up=0
            ele.down=1
            ele.stop=0
            ele.time=1
        else:
            continue
    if ele.stop==1:
        if ele.open_door==1:
            a=1-ele.floor/3
            b=2-ele.floor%3
            if ele.up==1:canvas.create_polygon((185+a*660,160+b*240,195+a*660,160+b*240,190+a*660,150+b*240),fill='grey')
            if ele.down==1:canvas.create_polygon((185+a*660,170+b*240,195+a*660,170+b*240,190+a*660,180+b*240),fill='grey')
            if ele.time>=17:
                ele.time=0
                ele.open_door=0
                ele.door=1
            time.sleep(0.01)
            open_door()
            continue
        if ele.close_door==1:
            if ele.time>=17:
                ele.time=0
                ele.close_door=0
                ele.door=0
            time.sleep(0.01)
            close_door()
            continue
        if ele.door==0:
            ele.time=0
            flag1=0        # 是否有人下
            for k in range(len(people0)):
                if people0[k].want==ele.floor:
                    flag1=1
            if flag1==1:
                ele.open_door=1
            if ele.up==1:
                flag=0
                for k in range(len(queue[ele.floor])):# 有人上
                    if queue[ele.floor][k].want>ele.floor:
                        flag=1;break
                if flag==1:ele.open_door=1;continue
                for k in range(ele.floor+1,6):
                    if queue[k]!=[]:
                        flag=1
                flag2=0
                for k in range(len(people0)):
                    if people0[k].want>ele.floor:
                        flag2=1;break;
                if flag==0 and flag2==0:
                    ele.up=0
                    ele.down=1
                    ele.open_door=1
                    ele.time=0
                    continue
                else:
                    if flag1==1:continue
                    ele.stop=0
                    ele.time=0
                    continue
            if ele.down==1:
                flag=0
                for k in range(len(queue[ele.floor])):# 有人上
                    if queue[ele.floor][k].want<ele.floor:
                        flag=1;break
                if flag==1:ele.open_door=1;continue
                for k in range(0,ele.floor):
                    if queue[k]!=[]:
                        flag=1
                flag2=0
                for k in range(len(people0)):
                    if people0[k].want<ele.floor:
                        flag2=1;break;
                if flag==0 and flag2==0:
                    ele.up=1
                    ele.down=0
                    ele.open_door=1
                    ele.time=0
                    continue
                else:
                    if flag1==1:continue
                    ele.stop=0
                    ele.time=0
                    continue
            else:
                ele.stop=0
                ele.time=0
                if people0!=[] and ele.up==0 and ele.down==0:
                    ele.up=1
                    continue
                if ele.up==1:
                    if ele.floor==5:
                        ele.down=1
                        ele.up=0
                        ele.time=0
                        continue
                    flag=0
                    for k in range(len(people0)):
                        if people0[k].want>ele.floor:
                            flag=1;break
                    for k in range(ele.floor+1,6):
                        if queue[k]!=[]:
                            flag=1;break
                    if flag==1:
                        ele.time=0
                        continue
                    else:
                        ele.down=1
                        ele.up=0
                        ele.time=0
                        continue
                if ele.down==1:
                    if ele.floor==0:
                        ele.down=0
                        ele.up=1
                        ele.time=0
                        continue
                    flag=0
                    for k in range(len(people0)):
                        if people0[k].want<ele.floor:
                            flag=1;break
                    for k in range(0,ele.floor):
                        if queue[k]!=[]:
                            flag=1;break
                    if flag==1:
                        continue
                    else:
                        ele.down=0
                        ele.up=1
                        continue               
        if ele.door==1:
            qq=0
            for k in range(len(people0)):
                if people0[k].want==ele.floor:
                    move_out(people0[k].image,200)
                    del(people0[k])
                    qq=1
                    break
            if qq:continue
            if ele.up==1:
                qq=0
                for k in range(len(queue[ele.floor])):
                    if queue[ele.floor][k].want>ele.floor:
                        move_in(queue[ele.floor][k].image)
                        queue[ele.floor][k].x-=200
                        people0.append(queue[ele.floor][k])
                        del(queue[ele.floor][k])
                        qq=1
                        break
                if qq:continue
            if ele.down==1:
                qq=0
                for k in range(len(queue[ele.floor])):
                    if queue[ele.floor][k].want<ele.floor:
                        move_in(queue[ele.floor][k].image)
                        queue[ele.floor][k].x-=200
                        people0.append(queue[ele.floor][k])
                        del(queue[ele.floor][k])
                        qq=1
                        break
                if qq:continue
            ele.time=0
            ele.close_door=1
            continue

    if ele.up==1:
        if ele.time==60:
            ele.stop=1
            ele.time=0
            ele.floor+=1
            move_dt(-1,people0)
            if ele.floor==3:
                move_big(-1,people0)
            continue
        time.sleep(0.01)
        move_dt(-1,people0)
        continue
    if ele.down==1:
        if ele.floor==0 and queue==[[],[],[],[],[],[]] and people0==[]:continue
        if ele.floor==3 and ele.time==1:
            move_big(1,people0)
        if ele.time==60:
            ele.stop=1
            ele.time=0
            ele.floor-=1
        time.sleep(0.01)
        move_dt(1,people0)
        continue
