# coding = UTF-8
import Tkinter
import math

window = Tkinter.Tk()
window.title("Shortest Path Enter")
window.geometry("600x500")

graph = []
vex_num = 0
pathlen = []
pathvex = []


def readgraph():
    global var
    string = var.get()
    f = open(string, "rb")
    list = f.readlines()
    vex_num = int(list[0][:-1])             # change the str into int
    split = list[1].split()
    vex = int(split[0])
    vextar = int(split[1])
    for i in range(vex_num):
        split = list[i+2].split()
        adjvertex = []
        for j in range(vex_num):
            adjvertex.append(int(split[j]))
        graph.append(adjvertex)
    f.close()                             # finish reading the file
    for i in range(vex_num):
        for j in range(i):
            graph[i][j] = graph[j][i]
    dijkstra(vex, vextar, vex_num)          # enlarge the matrix


def dijkstra(start, end, vex_num):
    vex = start
    vextar = end
    for i in range(vex_num):
        pathlen.append(-1)
        pathvex.append([])
    for i in range(vex_num):
        print(str(graph[i]))
    for i in range(vex_num):
        if graph[vex][i] != -1:
            pathlen[i] = graph[vex][i]
            pathvex[i].append(i)
    for m in range(vex_num):
        print(str(pathvex[m]))
    for k in range(vex_num):
        for i in range(vex_num):
            if pathlen[i] != -1:
                for j in range(vex_num):
                    if graph[i][j] != -1 and pathlen[j] == -1:     # adjacent i is not visited
                        pathlen[j] = graph[i][j] + pathlen[i]
                        pathvex[j] = pathvex[i][:]
                        pathvex[j].append(j)
                        for m in range(vex_num):
                            print(str(pathvex[m]))
                    if graph[i][j] != -1 and pathlen[j] != -1:     # adjacent i is visited
                        if pathlen[j] > graph[i][j] + pathlen[i]:
                            pathlen[j] = graph[i][j] + pathlen[i]  # refresh the shortest path length
                            pathvex[j] = pathvex[i][:]
                            pathvex[j].append(j)
                            for m in range(vex_num):
                                print(str(pathvex[m]))
    g = open("shortest_path.txt", "w")
    g.write("Shortest path:")
    g.write(str(pathlen[vextar]))
    g.write("\n")
    g.write(str(vex))

    for i in range(len(pathvex[vextar])):             # store the consequence into a txt file
        g.write("->")
        g.write(str(pathvex[vextar][i]))
    g.close()
    window2 = Tkinter.Toplevel(window)
    window2.geometry("700x700")
    window2.title("Graph")
    canvas = Tkinter.Canvas(window2, height=620, width=620)
    canvas.place(x=0, y=0)
    alpha = 2 * math.pi/vex_num
    vertice = []

    for i in range(vex_num):                                              #  graph open an another window
        x = 350 + 210 * math.sin(i * alpha)
        y = 310 + 210 * math.cos(i * alpha)
        v = canvas.create_oval(x-10, y-10, x+10, y+10, fill="blue")
        vertice.append(v)
    for i in range(vex_num):
        for j in range(vex_num):
            if graph[i][j] != -1:
                x1 = 350 + 210 * math.sin(i * alpha)
                x2 = 350 + 210 * math.sin(j * alpha)
                y1 = 310 + 210 * math.cos(i * alpha)
                y2 = 310 + 210 * math.cos(j * alpha)
                canvas.create_line(x1, y1, x2, y2, fill="grey")
                Tkinter.Label(window2, text=i, font=('HGMaruGothicMPRO', 16), fg='white',bg='blue').place(x=350 + 230 * math.sin(i * alpha), y=310 + 230 * math.cos(i * alpha))
    x1 = 350 + 210 * math.sin(vex * alpha)
    y1 = 310 + 210 * math.cos(vex * alpha)
    x2 = 350 + 210 * math.sin(pathvex[vextar][0] * alpha)
    y2 = 310 + 210 * math.cos(pathvex[vextar][0] * alpha)
    canvas.create_line(x1, y1, x2, y2, fill="yellow", width=5)
    for i in range(len(pathvex[vextar])-1):
        x1 = 350 + 210 * math.sin(pathvex[vextar][i] * alpha)
        y1 = 310 + 210 * math.cos(pathvex[vextar][i] * alpha)
        x2 = 350 + 210 * math.sin(pathvex[vextar][i + 1] * alpha)
        y2 = 310 + 210 * math.cos(pathvex[vextar][i + 1] * alpha)
        canvas.create_line(x1, y1, x2, y2, fill="yellow", width=5)
    Tkinter.Label(window2, text=pathlen[vextar], font=('HGMaruGothicMPRO', 16), fg='white',bg='dark blue').place(x=650, y=350)
    window2.mainloop()

Tkinter.Label(window,text='input complete filename',font=('HGMaruGothicMPRO',16),fg='white',bg='dark blue').place(x=180,y=170)
var = Tkinter.StringVar()
entry = Tkinter.Entry(window, textvariable= var, font=('HGMaruGothicMPRO', 16), width=20, show=None).place(x=180, y=200)

ch = Tkinter.Button(window, bg="blue", fg="yellow", text='Read Graph', font=('HGMaruGothicMPRO', 15), command=readgraph, width=15)
ch.place(x=190, y=350)

window.mainloop()

