/* 
 * This file is part of the TinCan R2D2 project
 *
 * Copyright (C) 2014 Stefan Wendler <sw@kaltpost.de>
 *
 * This software is free software; you can redistribute 
 * it and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * The software is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the JRocket firmware; if not, write to the Free
 * Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 * 02111-1307 USA.  
 */
 
public class Gui implements ButtonCallbackHandler
{    
  protected TextBox msg;
  protected TextBox info;
  protected PushButton auto;
  protected PushButton assist;
  protected PressButton effect;
  protected PressButton lrswitch;

  protected PressButton foreward;
  protected PressButton left;
  protected PressButton right;
  protected PressButton backward;
  
  protected boolean visible = false;

  protected KetaiBluetooth bt;

  protected int w;
  protected int h;

  protected PFont font;

  public Gui(PApplet p, int w, int h)
  {
    int b = 40;
    int cbs = 200;
    int abh = 80;
    
    this.w = w;
    this.h = h;
    
    if(w > 1280)
    {
      cbs = 300;
      abh = 120;
      font = loadFont("DroidSans-Bold-48.vlw");      
    }
    else
    {
      font = loadFont("DroidSans-Bold-31.vlw");
    }
    
    int abw = w - 3 * cbs - 4 * b;

    background(0);
    textFont(font);

    auto   = new PushButton("Autopilot", b, b, abw, abh, false, this);
    assist = new PushButton("Assistance", b, b + b / 2 + abh, abw, abh, true, this); 
    effect = new PressButton("Effect", b, 2 * b + 2 * abh, abw, abh, this); 
    lrswitch = new PressButton("Switch to lefty", b, 2 * b  + b / 2 + 3 * abh, abw, abh, this); 
    
    auto.setRgbBgHL(255, 250, 160);
    assist.setRgbBgHL(255, 250, 160);
    effect.setRgbBgHL(255, 250, 160);
    lrswitch.setRgbBgHL(255, 250, 160);
    
    foreward = new PressButton("Foreward", w - cbs - cbs - b, h / 2 - cbs - cbs / 2, cbs, cbs, this); 
    left = new PressButton("Left", w - cbs - cbs - cbs - b, h / 2 - cbs / 2, cbs, cbs, this); 
    right = new PressButton("Right", w - cbs - b, h / 2 - cbs / 2, cbs, cbs, this); 
    backward = new PressButton("Backward",  w - cbs - cbs - b, h / 2 + cbs / 2, cbs, cbs,  this);

    foreward.setRgbBg(255, 250, 160);
    left.setRgbBg(255, 250, 160);
    right.setRgbBg(255, 250, 160);
    backward.setRgbBg(255, 250, 160);
    
    foreward.setRgbBgHL(255, 10, 0);
    left.setRgbBgHL(255, 10, 0);
    right.setRgbBgHL(255, 10, 0);
    backward.setRgbBgHL(255, 10, 0);
    
    msg = new TextBox("TinControl v0.1", b, h - 2 * abh - b - b / 2, abw, abh);
    info = new TextBox("Info", b, h - abh - b, abw, abh);

    msg.setRgbBg(80, 255, 0);
    info.setRgbBg(80, 255, 0);
    
    p.registerMethod("mouseEvent", auto);
    p.registerMethod("mouseEvent", assist);
    p.registerMethod("mouseEvent", effect);
    p.registerMethod("mouseEvent", lrswitch);

    p.registerMethod("mouseEvent", foreward);
    p.registerMethod("mouseEvent", left);
    p.registerMethod("mouseEvent", right);
    p.registerMethod("mouseEvent", backward);

    p.registerMethod("draw", this);
  }

  public void switchToLeftyLayout()
  {
    int b = 40;
    int cbs = 200;
    int abh = 80;
    
    this.w = w;
    this.h = h;
    
    if(w > 1280)
    {
      cbs = 300;
      abh = 120;
    }
    
    int abw = w - 3 * cbs - 4 * b;
   
    background(0);
     
    auto.setDimensions(w - abw - b, b, abw, abh);
    assist.setDimensions(w - abw - b, b + b / 2 + abh, abw, abh); 
    effect.setDimensions(w - abw - b, 2 * b + 2 * abh, abw, abh); 
    lrswitch.setDimensions(w - abw - b, 2 * b + b / 2 + 3 * abh, abw, abh); 
    lrswitch.setLabel("Switch to righty");

    auto.setRgbBgHL(255, 215, 255);
    assist.setRgbBgHL(255, 215, 255);
    effect.setRgbBgHL(255, 215, 255);
    lrswitch.setRgbBgHL(255, 215, 255);
    
    foreward.setDimensions(cbs + b, h / 2 - cbs - cbs / 2, cbs, cbs); 
    right.setDimensions(cbs + cbs + b, h / 2 - cbs / 2, cbs, cbs); 
    left.setDimensions(b, h / 2 - cbs / 2, cbs, cbs); 
    backward.setDimensions(cbs + b, h / 2 + cbs / 2, cbs, cbs);

    foreward.setRgbBg(255, 215, 255);
    left.setRgbBg(255, 215, 255);
    right.setRgbBg(255, 215, 255);
    backward.setRgbBg(255, 215, 255);
    
    foreward.setRgbBgHL(255, 0, 250);
    left.setRgbBgHL(255, 0, 250);
    right.setRgbBgHL(255, 0, 250);
    backward.setRgbBgHL(255, 0, 250);
    
    msg.setDimensions(w - abw - b, h - 2 * abh - b - b / 2, abw, abh);
    info.setDimensions(w - abw - b, h - abh - b, abw, abh);
  }

  public void switchToRightyLayout()
  {
    int b = 40;
    int cbs = 200;
    int abh = 80;
    
    this.w = w;
    this.h = h;
    
    if(w > 1280)
    {
      cbs = 300;
      abh = 120;
    }
    
    int abw = w - 3 * cbs - 4 * b;
      
    background(0);
    
    auto.setDimensions(b, b, abw, abh);
    assist.setDimensions(b, b + b / 2 + abh, abw, abh); 
    effect.setDimensions(b, 2 * b + 2 * abh, abw, abh); 
    lrswitch.setDimensions(b, 2 * b + b / 2 + 3 * abh, abw, abh); 
    lrswitch.setLabel("Switch to lefty");

    auto.setRgbBgHL(255, 250, 160);
    assist.setRgbBgHL(255, 250, 160);
    effect.setRgbBgHL(255, 250, 160);
    lrswitch.setRgbBgHL(255, 250, 160);
    
    foreward.setDimensions(w - cbs - cbs - b, h / 2 - cbs - cbs / 2, cbs, cbs); 
    left.setDimensions(w - cbs - cbs - cbs - b, h / 2 - cbs / 2, cbs, cbs); 
    right.setDimensions(w - cbs - b, h / 2 - cbs / 2, cbs, cbs); 
    backward.setDimensions(w - cbs - cbs - b, h / 2 + cbs / 2, cbs, cbs);

    foreward.setRgbBg(255, 250, 160);
    left.setRgbBg(255, 250, 160);
    right.setRgbBg(255, 250, 160);
    backward.setRgbBg(255, 250, 160);
    
    foreward.setRgbBgHL(255, 10, 0);
    left.setRgbBgHL(255, 10, 0);
    right.setRgbBgHL(255, 10, 0);
    backward.setRgbBgHL(255, 10, 0);
    
    msg.setDimensions(b, h - 2 * abh - b - b / 2, abw, abh);
    info.setDimensions(b, h - abh - b, abw, abh);
  }
  
  public void registerBt(KetaiBluetooth bt)
  {
    this.bt = bt;
  }
  
  public void unregisterBt()
  {
    bt =null;
  }
  
  public void setMsg(String msg)
  {
    this.msg.setLabel(msg);
  }
  
  public void setVisible(boolean visible)
  {
    this.visible = visible;
  }
  
  public boolean isVisible()
  {
    return visible;
  }
  
  public void draw()
  {
    if(!visible)
    {
      return;
    }
  
    auto.draw();
    assist.draw();
    effect.draw();
    lrswitch.draw();

    foreward.draw();
    left.draw();
    right.draw();
    backward.draw();

    info.draw();
    msg.draw();
  }

  public void handleButtonEvent(String label, boolean pushed)
  {
    String l = label + " ";

    if (pushed)
    {
      l += "ON";
    }
    else
    {
      l += "OFF";
    }

    info.setLabel(l);

    println("BT-EVENT: " + label + " = " + pushed);
    
    if(pushed) 
    {
      if(label == "Foreward")
      {
        btSend(new byte[]{'+','d', ' ', 'f', '\r'});
      }
      else if(label == "Left")
      {
        btSend(new byte[]{'+','d', ' ', 'l', '\r'});
      }
      else if(label == "Right")
      {
        btSend(new byte[]{'+','d', ' ', 'r', '\r'});
      }
      else if(label == "Backward")
      {
        btSend(new byte[]{'+','d', ' ', 'b', '\r'});
      }
      else if(label == "Effect")
      {
        btSend(new byte[]{'+','p', '\r'});
      }
      else if(label == "Autopilot")
      {
        btSend(new byte[]{'+','a', 'p', ' ', '1', '\r'});
      }
      else if(label == "Assistance")
      {
        btSend(new byte[]{'+','d', 'a', ' ', '1', '\r'});
      }
      else if(label == "Switch to lefty")
      {
        switchToLeftyLayout();
      }
      else if(label == "Switch to righty")
      {
        switchToRightyLayout();
      }
    }
    else if(!pushed && (label == "Foreward" || label == "Left" || label == "Right" || label == "Backward"))
    {
      btSend(new byte[]{'+','d', ' ', 's', '\r'});
    }
    else if(!pushed)
    {
      if(label == "Autopilot")
      {
        btSend(new byte[]{'+','a', 'p', ' ', '0', '\r'});
      }
      else if(label == "Assistance")
      {
        btSend(new byte[]{'+','d', 'a', ' ', '0', '\r'});
      }
    }
  }
  
  protected void btSend(byte[] data)
  {
    if(bt == null)
    {
      return;
    }
    bt.broadcast(data);
  }
}
