#!/usr/bin/python3
from xml.etree import ElementTree
from time import time
from random import randint
from math import floor, ceil

class MindMap():
    def __init__(self, text, *children, position=None):
        self.text = text
        self.children = list(children)
        self.id = randint(1, 10 ** 10)
        self.position = position

    def __str__(self):
        return ('<node CREATED="' + str(round(time())) + '" ID="ID_' +
                str(self.id) + '" MODIFIED="' + str(round(time())) + '" ' +
                'TEXT="' + str(self.text) + '" ' + ('POSITION="' + self.position + '"' if self.position is not None else "") + '>\n' +
                "".join(list(map(lambda x: str(x), self.children))) + '</node>\n')

    def write(self, path):
        content = ('<map version="1.0.1">\n' + str(self) + "</map>\n")
        with open(path, "w") as f:
            f.write(content)

def xmlToMindMap(root):
    return MindMap(root.attrib["TEXT"], *map(xmlToMindMap, root),
                   position=root.attrib["POSITION"] if "POSITION" in root.attrib else None)

def loadMindMap(path):
    tree = ElementTree.parse(path)
    root = tree.getroot()
    return xmlToMindMap(root[0])

def countIndentationLevel(line):
    count = 0
    for character in line:
        if character == ' ':
            count += 1
        elif character == '\t':
            count += 4
        else:
            break
    return count

def distributeDirections(mindmap):
    childCount = len(mindmap.children)
    childsPerDirection = ceil(childCount / 2)

    for index in range(childCount):
        direction = floor(index / childsPerDirection)
        if direction == 0:
            mindmap.children[index].position = "left"
        elif direction == 1:
            mindmap.children[index].position = "right"


def loadHM(path):
    root = MindMap("")
    mapByDepth = lambda root, depth: root if depth == 0 else mapByDepth(root.children[-1], depth - 1)

    with open(path) as f:
        lineIndex = 0
        indentStack = [0]
        for line in f.readlines():
            line = line.strip("\n")
            lineIndex += 1
            indentationLevel = countIndentationLevel(line)
            try:
                depth = indentStack.index(indentationLevel)
            except ValueError:
                if indentationLevel > indentStack[-1]:
                    depth = len(indentStack)
                    indentStack.append(indentationLevel)
                else:
                    raise SyntaxError("Invalid indentation in Map line " + str(lineIndex))

            try:
                parent = mapByDepth(root, depth)
            except:
                raise SyntaxError("Skipped an indentation level on line " + str(lineIndex))

            parent.children.append(MindMap(line.strip(" \t")))

    if len(root.children) > 1:
        raise SyntaxError("A Map can only contain one top level element")
    elif len(root.children) == 0:
        raise SyntaxError("No element in MindMap")

    root = root.children[-1]
    distributeDirections(root)

    return root


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Usage:", sys.argv[0], "<hm file>", file=sys.stderr)
        sys.exit(1)
 
    try:
        hm = loadHM(sys.argv[1])
    except SyntaxError as x:
        print(str(x))
        sys.exit(1)
    hm.write(sys.argv[1] + ".mm")
