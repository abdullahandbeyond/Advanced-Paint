public class Cursor {
  
  PImage[] cursor_clicked;
  PImage cursor_unclicked;

  public Cursor(){
    //cursor images
    cursor_clicked = new PImage[6];
    cursor_unclicked = new PImage();
    
    //initialize the cursors with all the images 
    for (int i=0; i<cursor_clicked.length; i++) {
      cursor_clicked[i] = loadImage(String.format("%02d", i) + ".png");
    }
    cursor_unclicked = loadImage("00.png");
  }
  
  public void cursorCheck(boolean m_pressed) {
    //code for cursor_clicked
    int delay = 5;
    
    //show normal cursor on mouse unclicked
    if (m_pressed == false) {
      cursor(cursor_unclicked, 2, 28);
    }
    
    //code to draw
    if (m_pressed == true) {
      
      //draw line
      line(mouseX, mouseY, pmouseX, pmouseY);
      
      //animate cursor
      if(frameCount % delay == 0) {
       //nextFrame Codes goes here
       cursor(cursor_clicked[frameCount%cursor_clicked.length], 2, 28);
      }
    }
  }
}
