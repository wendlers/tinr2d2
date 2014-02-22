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

import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;
KetaiList klist;

Gui g;

TextBox discMsg;

byte cnt1 = 0;
byte cnt2 = 0;
  
void setup()
{
  //size(1280, 768);
  size(displayWidth, displayHeight);
  frameRate(15);
  orientation(LANDSCAPE);
 
  g = new Gui(this, displayWidth, displayHeight);
  
  println("W=" + displayWidth + ", H=" + displayHeight);
  
  //start listening for BT connections
  bt.start();
 
  background(0);
  discMsg = new TextBox("Discovering ...", 10, 10, displayWidth - 20, displayHeight - 20);
 
  bt.discoverDevices();
}

void draw()
{  
  if(!g.isVisible())
  {  
    if(bt.isDiscovering())
    {
      if(cnt1++ == 10)
      {
        cnt2++;
        if(cnt2 > 2)
        {
          cnt2 = 0;
        }
        cnt1 = 0;
      }
      
      int f1 = 0; 
      int f2 = 0;
      int f3 = 0;

      if(cnt2 == 0)
      {
        f1 = 128;
      }
      else if(cnt2 == 1)
      {
        f2 = 128;
      }
      else if(cnt2 == 2)
      {
        f3 = 128;
      }
      
      discMsg.draw();
            
      fill(f1);
      ellipse(displayWidth / 2 - 30, displayHeight / 2 + 60, 20, 20);
      fill(f2);
      ellipse(displayWidth / 2, displayHeight / 2 + 60, 20, 20);
      fill(f3);
      ellipse(displayWidth / 2 + 30, displayHeight / 2 + 60, 20, 20);
    }
    else
    {
      klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
      
      background(0);
      g.setVisible(true);
    }
  }
}

void onKetaiListSelection(KetaiList klist)
{  
  String selection = klist.getSelection();
  
  String name = selection;
  String addr = bt.lookupAddressByName(selection);

  // if canceled, discover again ...
  if(name == "")
  {
     println("Canceled ..");
     klist = null;
     g.setVisible(false);
     bt.discoverDevices();
     return;
  }
  
  println("Connecting to: " + name + " (" + addr + ")");
  bt.connectDevice(addr);
  
  try
  {
    Thread.sleep(750);
  }
  catch(Exception e)
  {
  }
   
  g.registerBt(bt);

  //dispose of list for now
  klist = null;
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  if(!g.isVisible())
    return;
    
  String s = new String(data);
  
  println("Received " + data.length +  " bytes : " + s);
  
  g.setMsg(s);
}

boolean surfaceKeyDown(int code, KeyEvent event) 
{
  if(event.getKeyCode() == KeyEvent.KEYCODE_BACK) 
  {
    if(g.isVisible())
    {      
      // back to selection
      g.setVisible(false);
      
      // restart bt to disconnect existing connections
      bt.stop();
      bt.start();
      
      bt.discoverDevices();
      return true;
    }
  }
  
  // else default key behavior is used
  return super.surfaceKeyDown(code, event);
}
//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
