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
 
public interface GenericBox
{
  public void draw();

  public void draw(int rgbBg[], int rgbBgHL[], int rgbTxt[]);

  public boolean isActivated();
}

public interface ButtonCallbackHandler
{
  public void handleButtonEvent(String label, boolean pushed);
}

public class TextBox implements GenericBox
{
  protected boolean activated = false;
  
  protected int x = 0;
  protected int y = 0;
  protected int w = 0;
  protected int h = 0;

  protected int rgbBg[]   = { 180, 180, 180 };
  protected int rgbBgHL[] = { 128, 128, 128 };
  protected int rgbTxt[]  = { 0, 0, 0 };
  
  protected String label = "_none_";
  
  public TextBox(String label, int x, int y, int w, int h)
  {
    this.label = label;
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  } 
  
  public void draw()
  {
   if(isActivated()) {
      fill(rgbBgHL[0], rgbBgHL[1], rgbBgHL[2]);
    }
    else {
      fill(rgbBg[0], rgbBg[1], rgbBg[2]);
    }

    rect(x, y, w, h);
    
    fill(rgbTxt[0], rgbTxt[1], rgbTxt[2]);
    textAlign(CENTER);
    text(label, x + w / 2, y + (h / 2) + (10));
  }

  public void draw(int rgbBg[], int rgbBgHL[], int rgbTxt[])
  {
    setRgbBg(rgbBg[0], rgbBg[1], rgbBg[2]);
    setRgbBgHL(rgbBgHL[0], rgbBgHL[1], rgbBgHL[2]);
    setRgbTxt(rgbTxt[0], rgbTxt[1], rgbTxt[2]);
    
    draw();
  }
  
  public void setDimensions(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void setLabel(String label)
  {
    this.label = label;
  }
  
  public void setRgbBg(int r, int g, int b)
  {
    rgbBg[0] = r;
    rgbBg[1] = g;
    rgbBg[2] = b;
  }
  
  public void setRgbBgHL(int r, int g, int b)
  {
    rgbBgHL[0] = r;
    rgbBgHL[1] = g;
    rgbBgHL[2] = b;
  }

  public void setRgbTxt(int r, int g, int b)
  {
    rgbTxt[0] = r;
    rgbTxt[1] = g;
    rgbTxt[2] = b;
  }
  
  public void setActivated(boolean activated)
  {
    this.activated = activated;
  }
  
  public boolean isActivated()
  {
    return activated;
  }
}

public abstract class GenericButton extends TextBox
{
  protected ButtonCallbackHandler handler = null;
  
  public GenericButton(String label, int x, int y, int w, int h)
  {
    super(label, x, y, w, h);
  }

  public GenericButton(String label, int x, int y, int w, int h, ButtonCallbackHandler handler)
  {
    super(label, x, y, w, h);
    this.handler = handler;

  }
  
  public void registerCallback(ButtonCallbackHandler handler)
  {
    this.handler = handler;
  }
  
  public void unregisterCallback()
  {
    this.handler = null;
  }  
  
  public void callback(boolean pushed)
  {
    if(handler != null)
    {
      handler.handleButtonEvent(label, pushed);
    }
  }
}

public class PressButton extends GenericButton
{
  public PressButton(String label, int x, int y, int w, int h)
  {
    super(label, x, y, w, h);
  }
  
  public PressButton(String label, int x, int y, int w, int h, ButtonCallbackHandler handler)
  {
    super(label, x, y, w, h);
    this.handler = handler;
  }
  
  public void mouseEvent(MouseEvent event)
  {
       if (mouseX >= x && mouseX <= x + w && 
           mouseY >= y && mouseY <= y + h && (event.getAction() == MouseEvent.DRAG || event.getAction() == MouseEvent.PRESS))
      {
        if(!activated)
        {
          callback(true);
          activated = true;
        }
      }
      else
      {
        if(activated)
        {
          callback(false);
          activated = false;
        }
      }
  } 
  
}

public class PushButton extends GenericButton
{
  
  public PushButton(String label, int x, int y, int w, int h, boolean activated)
  {
    super(label, x, y, w, h);
    this.activated = activated;
  }
  
  public PushButton(String label, int x, int y, int w, int h, boolean activated, ButtonCallbackHandler handler)
  {
    super(label, x, y, w, h);
    this.handler = handler;
    this.activated = activated;
  }
    
  public boolean isActivated()
  {
    return activated;
  }
  
  public void mouseEvent(MouseEvent event)
  {
       if (mouseX >= x && mouseX <= x + w && 
           mouseY >= y && mouseY <= y + h && event.getAction() == MouseEvent.RELEASE)
      {
        activated = !activated;
        callback(activated);
      }
  } 
}
