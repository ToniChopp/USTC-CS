import Tkinter as tk
import struct
import pickle

window=tk.Tk()
window.mainloop()
window.title('Huffman Zipper')
window.geometry('400x250')
 
type = int(raw_input('please input the type number(0 for compress, 1 for decompress):'))
file = raw_input('please input the filepath:')
 
#initial 
class Node:
    def __init__(self):
        self.value = ''
        self.left = None
        self.right = None
        self.frequency = 0
        self.code = ''
 
 
# let the unique value be the key in the map
def change_value_to_key(huffmap):
    map = {}
    for (key, value) in huffmap.items():
        map[value] = key
    return map
 
 
if type == 0:
    origindata = ''    # 计数权值
    lettermap = {}
 
    def give_code(node):     #定义编码规则
        if node.left:
            node.left.code = '%s%s' % (node.code, '0')
            give_code(node.left)
        if node.right:
            node.right.code = '%s%s' % (node.code, '1')
            give_code(node.right)
 
 
    def print_code(node):      
        if not node.left and not node.right:
            print "%s %s" % (node.value, node.code)
        if node.left:
            print_code(node.left)
        if node.right:
            print_code(node.right)
 
 
    def save_code(map, node):      #存储编码
        if not node.left and not node.right:
            map[node.value] = node.code
        if node.left:
            save_code(map, node.left)
        if node.right:
            save_code(map, node.right)
 
 
    with open(file)as f:
        for line in f.readlines():
            origindata += line
            for j in line:
                if lettermap.get(j):
                    lettermap[j] += 1
                else:
                    lettermap[j] = 1
    nodelist = []
    for (key, value) in lettermap.items():
        node = Node()
        node.value = key
        node.frequency = value
        nodelist.append(node)
    nodelist.sort(cmp=lambda n1, n2: cmp(n1.frequency, n2.frequency))
    for i in range(len(nodelist) - 1):                #权值排序
        node1 = nodelist[0]               
        node2 = nodelist[1]
        node = Node()
        node.left = node1
        node.right = node2
        node.frequency = node1.frequency + node2.frequency
        nodelist[0] = node
        nodelist.pop(1)
        nodelist.sort(cmp=lambda n1, n2: cmp(n1.frequency, n2.frequency))
    root = nodelist[0]          #编码赋值
    give_code(root)
    huffman_map = {}
    save_code(huffman_map, root)
    code_data = ''
    for letter in origindata:
        code_data += huffman_map[letter]
    output_data = ''
    f = open('%s.huff' % file, 'wb')
    huffman_map_bytes = pickle.dumps(huffman_map)
    f.write(struct.pack('I', len(huffman_map_bytes)))
    f.write(struct.pack('%ds' % len(huffman_map_bytes), huffman_map_bytes))
    f.write(struct.pack('B', len(code_data) % 8))
    for i in range(0, len(code_data), 8):
        if i + 8 < len(code_data):
            f.write(struct.pack('B', int(code_data[i:i + 8], 2)))
        else:
            f.write(struct.pack('B', int(code_data[i:], 2)))
    f.close()
    print 'finished compressing'
if type == 1:
    f = open(file, 'rb')
    size = struct.unpack('I', f.read(4))[0]
    huffman_map = pickle.loads(f.read(size))
    left = struct.unpack('B', f.read(1))[0]
    data = f.read(1)
    datalist = []
 
    while not data == '':
        bdata = bin(struct.unpack('B', data)[0])[2:]
        datalist.append(bdata)
        data = f.read(1)
    f.close()
    for i in range(len(datalist) - 1):
        datalist[i] = '%s%s' % ('0' * (8 - len(datalist[i])), datalist[i])
    datalist[-1] = '%s%s' % ('0' * (left - len(datalist[-1])), datalist[-1])
    encode_data = ''.join(datalist)
    current_code = ''
    huffman_map = change_value_to_key(huffman_map)
    f = open('%s.huff' % file, 'w')
    for letter in encode_data:
        current_code += letter
        if huffman_map.get(current_code):
            f.write(huffman_map[current_code])
            current_code = ''
    f.close()
 
    print 'finished decompressing'
