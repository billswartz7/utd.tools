#!/usr/bin/env python3

import sys
import turtle
from tkinter import *

class utDturtle(turtle.RawTurtle): # here we subclass the turtle to allow us to call statusbar updates after each movement
    xoffset = 0
    yoffset = 0
    scale = 0.75
    def __init__(self, canvas):
        turtle.RawTurtle.__init__(self, canvas)
        self.bbox = [0,0,0,0]

    def _update_bbox(self): # keep a record of the furthers points visited
        pos = self.position()
        if pos[0] < self.bbox[0]:
            self.bbox[0] = pos[0]
        elif pos[0] > self.bbox[2]:
            self.bbox[2] = pos[0]
        if pos[1] < self.bbox[1]:
            self.bbox[1] = pos[1]
        elif pos[1] > self.bbox[3]:
            self.bbox[3] = pos[1]

    def _update_bbox_pt(self,x,y): # keep a record of the furthers points visited
        if x < self.bbox[0]:
            self.bbox[0] = x
        elif x > self.bbox[2]:
            self.bbox[2] = x
        if y < self.bbox[1]:
            self.bbox[1] = y
        elif y > self.bbox[3]:
            self.bbox[3] = y

    def _update_bbox_rect(self,x1,y1,x2,y2): # keep a record of the furthers points visited
        if x1 < self.bbox[0]:
            self.bbox[0] = x1
        elif x1 > self.bbox[2]:
            self.bbox[2] = x1
        if y1 < self.bbox[1]:
            self.bbox[1] = y1
        elif y1 > self.bbox[3]:
            self.bbox[3] = y1
        if x2 < self.bbox[0]:
            self.bbox[0] = x2
        elif x2 > self.bbox[2]:
            self.bbox[2] = x2
        if y2 < self.bbox[1]:
            self.bbox[1] = y2
        elif y2 > self.bbox[3]:
            self.bbox[3] = y2

    def forward(self, *args):
        turtle.RawTurtle.forward(self, *args)
        self._update_bbox()

    def backward(self, *args):
        turtle.RawTurtle.backward(self, *args)
        self._update_bbox()

    def right(self, *args):
        turtle.RawTurtle.right(self, *args)
        self._update_bbox()

    def left(self, *args):
        turtle.RawTurtle.left(self, *args)
        self._update_bbox()

    def dot(self, *args):
        turtle.RawTurtle.dot(self, *args)
        self._update_bbox()

    def goto(self, *args):
        turtle.RawTurtle.goto(self, *args)
        self._update_bbox()

    def setx(self, *args):
        turtle.RawTurtle.setx(self, *args)
        self._update_bbox()

    def sety(self, *args):
        turtle.RawTurtle.sety(self, *args)
        self._update_bbox()

    def setheading(self, *args):
        turtle.RawTurtle.setheading(self, *args)
        self._update_bbox()

    def home(self, *args):
        self._update_bbox()

    def border(self, screen_x, screen_y):
        """(Turtle, int, int)

        Draws a border around the canvas in red.
        """
        # Lift the pen and move the turtle to the center.
        t = turtle
        t.penup()
        t.home()

        # Move to lower left corner of the screen; leaves the turtle
        # facing west.
        t.forward(screen_x / 2)
        t.right(90)
        t.forward(screen_y / 2)
        t.setheading(180)           # t.right(90) would also work.

        # Draw the border
        t.pencolor('red')
        t.pendown()
        t.pensize(10)
        for distance in (screen_x, screen_y, screen_x, screen_y):
            t.forward(distance)
            t.right(90)
            self._update_bbox()
        
        # Raise the pen and move the turtle home again; it's a good idea
        # to leave the turtle in a known state.
        t.penup()
        t.home()

    def draw_rect( self, x1, y1, x2, y2, color, fill, pensize ):
        """(Turtle, left bottom point, right top point, color)
        Draws a rectangle of the given coordinate in a given color
        
        """
        t = turtle
        self._update_bbox_rect( x1, y1, x2, y2 )
        if x1 <= x2:
          startx = x1 - self.xoffset
          width = x2 - x1
        else:
          startx = x2 - self.xoffset
          width = x1 - x2
        if y1 <= y2:
          starty = y1 - self.yoffset
          height = y2 - y1
        else:
          starty = y2 - self.yoffset
          height = y1 - y2


        startx_float = float(startx) * self.scale
        starty_float = float(starty) * self.scale
        width_float = float(width) * self.scale
        height_float = float(height) * self.scale
        startx = int(startx_float)
        starty = int(starty_float)
        width = int(width) * self.scale
        height = int(height) * self.scale

        t.penup()
        t.goto(startx, starty)
        t.pensize(pensize)
        t.pencolor(color)
        t.pendown()
        t.setheading(90)
        if fill:
          t.begin_fill()
          t.fillcolor(color)
        for side in range(2):
          t.forward(height)
          t.right(90)
          t.forward(width)
          t.right(90)
        if fill:
          t.end_fill()

    def draw_line( self, x1, y1, x2, y2, color, pensize ):
        """(Turtle, left bottom point, right top point, color)
        Draws a rectangle of the given coordinate in a given color
        
        """
        t = turtle
        self._update_bbox_rect( x1, y1, x2, y2 )
        t.penup()
        x1 -= self.xoffset
        y1 -= self.yoffset
        x1_float = float(x1) * self.scale
        y1_float = float(y1) * self.scale
        x1 = int(x1_float)
        y1 = int(y1_float)
        t.goto(x1, y1)
        t.pensize(pensize)
        t.pencolor(color)
        t.pendown()
        x2 -= self.xoffset
        y2 -= self.yoffset
        x2_float = float(x2) * self.scale
        y2_float = float(y2) * self.scale
        x2 = int(x2_float)
        y2 = int(y2_float)
        t.goto(x2, y2)
        t.penup()

    def draw_dot( self, x, y, size, color ):
        """(Turtle, center of filled circle, diameter of circle, color)
        Draws a filled circle of the given coordinate in a given color
        
        """
        t = turtle
        self._update_bbox_pt(x,y)
        t.penup()
        x -= self.xoffset
        y -= self.yoffset
        x_float = float(x) * self.scale
        y_float = float(y) * self.scale
        x = int(x_float)
        y = int(y_float)
        t.goto(x, y)
        self._update_bbox()
        t.pendown()
        t.dot( size, color )

    def draw_text( self, str_value, x, y, color, align_val ):
        """(Turtle, text itself, text point, color of text and lastly alignment)
        Draws text at a point and given alignment.
        
        """
        t = turtle
        self._update_bbox_pt(x,y)
        t.penup()
        x -= self.xoffset
        y -= self.yoffset
        x_float = float(x) * self.scale
        y_float = float(y) * self.scale
        x = int(x_float)
        y = int(y_float)
        t.goto(x, y)
        t.pencolor(color)
        t.pendown()
        t.write( str_value, True, align=align_val, font=("Arial", 24, "normal"))

    def draw_offset(self, xoffset, yoffset):
        self.xoffset = xoffset
        self.yoffset = yoffset

    def draw_scale(self, scale):
        self.scale = scale

    def zoom_in(self):
        self.scale = self.scale * 1.5

    def zoom_out(self):
        self.scale = self.scale / 1.5

    def scale_set(self):
        print(f'Enter the scale [0.0...1.0]:')
        scale = input() ;
        scale_float = float(scale)
        if scale_float < 0.0:
            print(f'Invalid scale: {scale_float}.  Ignored.')
            return
        if scale_float > 1.0:
            print(f'Invalid scale: {scale_float}.  Ignored.')
            return
        self.scale = scale_float

def utDturtle_init( width, height ):
    # Create screen and turtle.
    canvas = turtle.getcanvas()
    root = canvas.winfo_toplevel()
    root_children = root.winfo_children() 
    canvas_children = canvas.winfo_children()
    sbar = root_children[2]
    cvas = root_children[1]
    cvas2 = root_children[0]
    vals = sbar.config()
    cvas.config(scrollregion=(-2000,-2000,2000,2000))
    cvas.config(xscrollincrement=10)
    cvas.config(yscrollincrement=10)
    # cvas.config(width=500)
    # cvas.config(height=500)
    cvas.config(relief=RAISED)
    buttonFrame = Frame(root)
    zoomIn = Button(buttonFrame,text="zoom In")
    zoomOut = Button(buttonFrame,text="zoom Out")
    buttonFrame.pack(side=BOTTOM)
    zoomIn.pack(side=LEFT)
    zoomOut.pack(side=LEFT)
    cvals = cvas.config()
    # print(cvals)    
    cv = turtle.ScrolledCanvas(root)
    screen = turtle.TurtleScreen(cv)
    screen.screensize(width, height)
    t = utDturtle(screen)
    zoomIn.config(command=t.zoom_in)
    zoomOut.config(command=t.zoom_out)
    return t
