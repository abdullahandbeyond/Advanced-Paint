public class CurrentSelection {
  
  public void showSelection(int line_weight, int line_color, int shape) {

    strokeWeight(1);
    stroke(200);
    rect(width-150, 0, 140, 70); // rect(525, 0, 110, 50);

    currentSelection(line_weight, line_color, shape);
  }
  
  public void blinkSelection() {
      rect (width-150, 0, 140, 70); //  rect(525, 0, 110, 50);
  }

  /* show selected features
  */
  private void currentSelection(int line_weight, int line_color, int shape) {
    
    strokeWeight(line_weight);
    stroke(line_color); //rectMode(RADIUS);
    
    //fill(230);
    if (shape == 0) {
        float x = 0;
        for (x=width-130; x<width-20; x++) {
            float y = (35) + 10.0 * (float) Math.sin(Math.toRadians((double)x) *4.5 );
            point( x, y);
        }
    }
    else if (shape == 1) {
        line(width-130, 35, width-20, 35);
    }
    else if (shape == 2) {
        rect(width-135, 15, 110, 40); // rect(width-100, height-470, 80, 30);
    }
    else if (shape == 3) {
        ellipseMode(CENTER);
        ellipse(width-80, 35, 110, 40); // ellipse(580, 25, 80, 30);
    }
  }
  
  /*check for shortcut keys
  */
  public void shortcut(char ip){
    
    if(ip == '1') {
    line_weight = 1;
    }
    else if(ip == '2') {
      line_weight = 4;
    }
    else if(ip == '3') {
      line_weight = 10;
    }
    
    else if(ip == 'a') { //black=0, red=FF0000, green=00FF00, blue=0000FF
      line_color = 0;
    }
    else if(ip == 's') {
      line_color = #FF0000; //red=#FF0000
    }
    else if(ip == 'd') {
      line_color = #00FF00; //green=#00FF00
    }
    else if(ip == 'f') {
      line_color = #0000FF; //blue=0000FF
    }
    
    /* Shortcut: Undo functionality of free-form lines
    */
    if (ip == BACKSPACE) {
        
        if (!lines.isEmpty() && !undo_lines.isEmpty()) {
            for (int i=undo_lines.get(undo_lines.size()-1).ep; i>=undo_lines.get(undo_lines.size()-1).sp; i--) { //delete starting from last of undo_lines
                lines.remove(i);
                shape_tracker.remove(i);
            }
            
            undo_lines.remove(undo_lines.size()-1);
            //shape_tracker.remove(shape_tracker.size()-1);
        }
    }
    
    /* Shortcut: q = free form lines, w = straight lines, e = ellipse, r = rectangle
    */
    if (ip == 'q') {
        shape = 0;
    }
    if (ip == 'w') {
        shape = 1;
    }
    if (ip == 'r') {
        shape = 2;
    }
    if (ip == 'e') {
        shape = 3;
    }
  }
}
