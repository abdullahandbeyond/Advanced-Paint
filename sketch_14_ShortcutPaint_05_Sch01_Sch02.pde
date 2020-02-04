import de.voidplus.dollar.*;

/* ArrayList of Line and UndoLine for free-form lines and Shape Tracker
*/
ArrayList<Line> lines = new ArrayList<Line>();
ArrayList<UndoLine> undo_lines = new ArrayList<UndoLine>();
ArrayList<ShapeTracker> shape_tracker = new ArrayList<ShapeTracker>();

/* ArrayList of Straight Line points
*/
ArrayList<PVector> straight_line_points = new ArrayList<PVector>();

/* Starting Points and End Points for the `undo_lines`
*/
int undo_sp, undo_ep;

/* Functionality: Line weight, color & shape = means free-form line(0), Straight line(1), Rectangle(2), Ellipse(3) 
*/
int line_weight = 4, line_color = 0, shape = 0;

/*cursor images
*/
Cursor cursor_obj;

/*initialize selection showing
*/
CurrentSelection select_obj;

/* boolean variable for tracking left mouse button click
*/
boolean right_mouse_button = false;

/* One-Dollar Gesture Components
*/
OneDollar one;
String gesture_name;

void mousePressed() {
    
    if (mouseButton == LEFT) {
        
        /* Set starting point of Undo point functionality
        */
        if (lines.size()>0) {
            undo_sp = lines.size(); //undo_sp = undo_ep + 1;
        }
        else if (lines.size() == 0) {
            undo_sp = 0;
        }
        
        /* Track points for the straight line
        */
        if (shape != 0) {
            straight_line_points.add(new PVector(mouseX, mouseY));
        }
        
        right_mouse_button = false;
    }
    
    else {
        right_mouse_button = true;
    }
}

void mouseReleased () {
    select_obj.blinkSelection();
    
    if (!right_mouse_button) {
        
        /* For straight lines, adds the straight lines using the respective start and end points
        */
        if (shape != 0) {
            straight_line_points.add(new PVector(mouseX, mouseY));
            lines.add(new Line(straight_line_points.get(straight_line_points.size()-2).x, straight_line_points.get(straight_line_points.size()-2).y, straight_line_points.get(straight_line_points.size()-1).x, straight_line_points.get(straight_line_points.size()-1).y));
            
            /* Keeps track of the shapes used (i.e. straight lines, rect, ellipse etc.)
            */
            shape_tracker.add(new ShapeTracker(lines.size()-1, shape, line_weight, line_color));    /* ***************** SHAPE TRACKER for other than free lines ******************** */
            
            /* Remove the straight_line_points
            */
            for (int i=straight_line_points.size()-1; i>=0; i--) {
                straight_line_points.remove(i);
            }      
        }
        
        /* Set ending point of Undo point functionality and adds undo_lines
        */
        undo_ep = lines.size()-1;
        undo_lines.add(new UndoLine (undo_sp, undo_ep));
    }
    else {
        if (gesture_name == "freel") {
            select_obj.shortcut('q');
        }
        else if (gesture_name == "straightl") {
            select_obj.shortcut('w');
        }
        else if (gesture_name == "ellipse") {
            select_obj.shortcut('e');
        }
        else if (gesture_name == "rectangle") {
            select_obj.shortcut('r');
        }
        else if (gesture_name == "thin") {
            select_obj.shortcut('1');
        }
        else if (gesture_name == "medium") {
            select_obj.shortcut('2');
        }
        else if (gesture_name == "thick") {
            select_obj.shortcut('3');
        }
        else if (gesture_name == "red") {
            select_obj.shortcut('s');
        }
        else if (gesture_name == "green") {
            select_obj.shortcut('d');
        }
        else if (gesture_name == "blue") {
            select_obj.shortcut('f');
        }
        else if (gesture_name == "black") {
            select_obj.shortcut('a');
        }
        
    }
}

/* OD Track data
*/
void mouseDragged(){
    if (mouseButton == RIGHT) {
        one.track(mouseX, mouseY);
    }
}

void keyPressed() {
    
    select_obj.shortcut(key);
}

void setup() {
    size(800, 600);
    background(255);
    
    /* Initialize cursor and selection
    */
    cursor_obj = new Cursor();
    select_obj = new CurrentSelection();
    
    /* Initialize OD
    */
    setupOD ();
}

void draw() {
    noFill();
    background(255);
    
    /*show selection of features
    */
    select_obj.showSelection(line_weight, line_color, shape);
  
    /*show cursor
    */
    cursor_obj.cursorCheck(mousePressed);
      
    /* Draw instant free-form lines and adds traker
    */
    if(mousePressed  && (mouseButton == LEFT) && shape == 0) {
        lines.add(new Line (pmouseX, pmouseY, mouseX, mouseY));
        shape_tracker.add(new ShapeTracker(lines.size()-1, shape, line_weight, line_color));    /* ***************** SHAPE TRACKER for free lines ******************** */
        
    }
    
    /* Draw instant straight lines
    */
    else if (mousePressed  && (mouseButton == LEFT)  && shape == 1) {
        for (int i = 0; i < straight_line_points.size(); i += 2) {
            PVector p1 = straight_line_points.get(i);
            boolean even = i+1 < straight_line_points.size();
            PVector p2 = even ? straight_line_points.get(i+1) : new PVector(mouseX, mouseY);
            line(p1.x, p1.y, p2.x, p2.y);
        }
    }
    
    /* Draw instant rectangles
    */
    else if (mousePressed  && (mouseButton == LEFT)  && shape == 2) {
        for (int i = 0; i < straight_line_points.size(); i += 2) {
            PVector p1 = straight_line_points.get(i);
            boolean even = i+1 < straight_line_points.size();
            PVector p2 = even ? straight_line_points.get(i+1) : new PVector(mouseX, mouseY);
            rect(p1.x, p1.y, p2.x-p1.x, p2.y-p1.y);
        }
    }
    
    /* Draw instant ellipse
    */
    else if (mousePressed  && (mouseButton == LEFT)  && shape == 3) {
        for (int i = 0; i < straight_line_points.size(); i += 2) {
            PVector p1 = straight_line_points.get(i);
            boolean even = i+1 < straight_line_points.size();
            PVector p2 = even ? straight_line_points.get(i+1) : new PVector(mouseX, mouseY);
            ellipseMode(CORNER);
            ellipse(p1.x, p1.y, p2.x-p1.x, p2.y-p1.y);
        }
    }
    
    
    
    /* Draw all the lines within the loop
    */
    displayLines();
    
    /* OD draw
    */
    if (mouseButton == RIGHT) {
        one.draw();
    }
}

void displayLines(){
    for (int i=0; i<lines.size(); i++) {
        
        if (shape_tracker.get(i).shape == 1 || shape_tracker.get(i).shape == 0) {
            
            //thickness and color
            strokeWeight(shape_tracker.get(i).line_weight);
            stroke(shape_tracker.get(i).line_color);
            
            //draw lines for shapes 0 and 1
            line(lines.get(i).x1, lines.get(i).y1, lines.get(i).x2, lines.get(i).y2);
        }
        
        else if (shape_tracker.get(i).shape == 2) {
            
            //thickness and color
            strokeWeight(shape_tracker.get(i).line_weight);
            stroke(shape_tracker.get(i).line_color);
            
            //draw rectangles for shape = 2
            rect(lines.get(i).x1, lines.get(i).y1, lines.get(i).x2-lines.get(i).x1, lines.get(i).y2-lines.get(i).y1);
        }
        
        else if (shape_tracker.get(i).shape == 3) {
            //thickness and color
            strokeWeight(shape_tracker.get(i).line_weight);
            stroke(shape_tracker.get(i).line_color);
            
            //draw ellipses for shape = 3
            ellipseMode(CORNER);
            ellipse(lines.get(i).x1, lines.get(i).y1, lines.get(i).x2-lines.get(i).x1, lines.get(i).y2-lines.get(i).y1);
        }
        
    }
}

/*setup OneDollar
*/
void setupOD () {
    
    gesture_name = "-";
  
    // Create instance of class OneDollar:
    one = new OneDollar(this);
    println(one);                  // Print all the settings
  
    one.setVerbose(true);          // Activate console verbose
  
    // Add gestures (templates):
    one.learn("ellipse", new int[] {296,94,291,94,285,95,278,96,272,97,267,99,261,100,257,102,254,103,250,104,248,104,247,106,245,107,244,109,243,110,238,112,233,114,227,116,220,118,213,121,204,123,196,126,189,128,183,130,177,132,174,133,171,135,169,136,168,138,167,139,165,140,164,141,164,143,163,145,161,147,161,150,159,153,158,156,156,159,154,162,153,164,153,167,152,172,151,175,151,179,151,184,151,187,152,193,153,196,153,199,153,201,154,203,155,206,157,210,157,213,159,219,161,223,163,226,165,230,168,232,171,235,175,237,177,240,179,241,181,244,186,246,191,249,195,252,201,255,207,257,213,259,220,261,227,263,235,265,244,267,252,268,260,268,268,268,276,268,284,268,291,267,298,266,303,265,310,263,316,262,322,261,327,259,333,257,337,256,341,255,344,253,347,251,351,250,354,248,356,247,358,245,361,244,362,240,364,239,365,237,367,235,368,233,369,232,370,230,370,227,370,224,371,222,371,220,372,218,372,216,372,215,372,214,372,213,372,211,372,210,372,208,372,207,371,206,370,204,369,203,369,201,368,200,367,199,366,197,365,196,363,194,362,193,361,192,360,192,359,190,357,189,356,188,354,187,353,186,351,185,350,184,349,183,347,183,346,182,345,181,343,181,342,179,341,179,339,178,338,177,336,176,335,176,334,175,332,175,331,174,330,174,328,174,327,174,326,173,324,173,323,173,322,173,320,172,318,172,316,172,313,172,310,172,308,172,304,172,298,173,293,175,287,176,281,178,276,180,270,182,265,183,260,185,257,185,256,186,255,187,253,187,253,188,252,188,251,190,250,191,248,191,247,193,245,194,244,195,243,196} );

    one.learn("freel", new int[] {120,198,120,196,120,193,119,192,119,188,119,185,119,182,119,180,119,178,120,176,121,173,123,171,124,170,126,167,127,166,129,164,132,163,136,161,139,160,144,158,147,156,149,156,150,156,152,156,153,158,155,159,157,163,158,169,159,175,160,180,160,186,160,191,160,199,160,205,160,213,160,220,159,225,159,231,159,235,159,239,159,241,160,242,161,244,162,244,162,245,163,246,164,246,166,246,167,246,168,245,170,244,171,242,174,239,175,237,177,233,179,227,181,222,181,218,182,214,182,211,182,207,182,204,182,202,182,201,181,200,181,199,181,198,181,196,180,196} );
    one.learn("straightl", new int[] {68,232,69,232,72,232,75,231,77,231,79,231,80,230,82,230,85,229,87,229,89,229,90,229,92,229,93,229,94,229,95,229,97,229,98,229,99,229,101,228,102,228,103,228,105,227,106,227,107,227,108,227,110,227,111,227,113,227,114,227,115,227,116,227,118,227,119,227,120,227,122,227,123,227,125,227,126,227,127,227,128,227,129,227,130,227,131,227,133,227,134,227,135,227,137,227,138,227,139,227,140,227,142,227,143,227,144,227,146,226,147,226,148,226,149,226,151,226,152,226,153,226,154,226,155,226,156,226,158,226,159,226,160,226,161,226,162,226,163,226,165,226,166,227,167,227,169,227,170,228,171,228,173,228,174,228,175,228,177,229,178,229,179,229,180,229,181,230,182,230,182,231,184,231,185,231,186,231,187,231,189,231,190,231,191,232,192,232,193,232,195,232,196,232,197,232,198,232,200,232,201,233,202,233,203,233,204,233,206,233,207,233,209,233,210,233,211,233,212,233,213,233,214,233,215,233,216,233,217,233,218,233,220,233,221,233,222,233,223,233,225,233,226,233,227,233,228,233,229,233,230,233,231,233,232,233,233,233,234,233,236,233,237,233,238,233,240,233,241,233,242,233,243,234,245,234,246,234,247,234,249,234,250,234,251,234,252,234,253,234,255,234,256,234,257,234,259,234,260,234,261,234,262,234,264,235,265,235,267,236,268,236,269,236,270,236,271,236,272,236,273,237,274,237,275,237,276,237,278,238,279,238,280,238,281,238,282,238,284,238,285,238,287,238,288,238,289,238,291,238,292,238,293,238,294,238,296,238,297,238,298,238,299,238,301,238,302,238,304,238,305,238,306,238,307,238,309,238,310,238,311,238,312,238,313,238,314,238,315,238,316,238,317,238,318,238,320,238,321,238,322,238,323,238,325,237,327,237,329,237,330,237,332,237,334,237,335,237,336,237,338,237,339,237,340,236,341,236,342,236,344,236,345,236,346,236,348,236,349,236,350,236,351,236,353,236,354,236,355,236,357,236,358,236,360,236,361,236,363,236,364,236,365,236,366,236,368,236,369,236,371,236,372,236,373,236,374,236,375,236,376,236,377,236,378,236,379,236,380,235,381,235,382,235,383,235,384,235,385,235} );
    one.learn("rectangle", new int[] {165,162,166,164,166,165,167,166,167,168,167,169,167,170,167,171,167,172,168,173,168,174,168,175,168,177,168,178,168,179,168,181,168,182,168,183,168,184,168,186,169,187,169,188,169,190,169,191,169,192,169,193,169,195,169,196,169,197,169,199,169,200,169,201,169,202,169,204,169,206,169,207,169,208,169,209,169,211,169,212,169,213,169,215,169,216,169,217,169,218,169,220,169,221,169,222,169,224,169,225,168,226,168,228,168,229,168,230,168,231,168,233,168,234,168,235,168,236,168,238,168,239,168,240,168,242,168,243,168,244,168,245,168,246,168,247,168,248,168,249,170,250,171,251,172,251,175,251,177,251,178,251,180,251,182,251,184,251,186,250,188,249,189,249,191,249,192,249,193,249,194,249,196,249,197,249,198,249,200,248,202,248,204,248,206,248,207,248,210,248,211,248,212,248,213,248,215,248,216,248,217,248,219,248,221,248,223,248,226,249,228,249,231,249,234,249,237,249,240,249,242,249,245,249,247,249,249,249,251,248,252,248,254,247,255,247,256,247,257,247,259,247,260,247,261,247,263,247,264,246,265,246,267,246,268,245,269,245,271,245,272,245,273,245,274,245,276,244,277,244,278,244,279,244,280,244,281,243,282,243,283,243,284,243,285,243,286,243,287,243,288,243,289,243,290,243,291,243,292,242,292,241,293,240,293,237,294,235,294,233,294,232,294,231,294,229,294,228,294,227,294,225,294,224,294,223,294,222,294,220,294,219,294,218,294,216,294,215,294,214,294,213,294,211,294,210,294,209,293,207,293,206,293,205,293,204,293,202,293,201,293,200,293,198,293,197,292,196,292,194,292,193,292,192,292,191,292,189,292,188,292,187,292,186,291,185,291,184,291,183,291,182,291,180,290,179,290,178,290,177,290,175,289,174,289,173,289,171,289,170,288,169,288,167,288,166,288,165,287,164,287,163,287,162,287,161,287,160,286,159,286,158,285,157,283,157,282,157,279,156,277,156,275,156,273,156,271,155,269,155,267,155,266,155,264,155,262,155,260,155,257,155,256,155,255,155,253,155,252,155,250,156,249,156,247,157,246,158,245,158,242,159,240,160,238,160,236,161,234,162,233,162,232,163,230,164,228,165,227,165,225,165,223,165,222,165,221,166,219,166,218,166,216,167,215,167,214,167,212,167,210,167,209,168,208,168,206,168,205,168,204,169,202,169,201,169,200,169,199,169,197,169,196,169,195,169,193,169,192,169,191,169,190,169,187,169,186,169,185,170,183,170,182,170,181,170,180,170,178,171,177,171,176,171,175,171,174,171,173,171,171,171,170,171,169,171,168,171,167,171,166,171,165,171,164,171,163,171,162,171} );
    // alpha, beta, gamma
    one.learn("thin", new int[] {242,181,242,182,242,184,242,187,242,191,241,195,241,198,240,202,239,205,237,210,235,213,235,217,233,219,232,222,231,224,229,226,228,228,226,230,225,232,224,234,220,236,219,238,216,241,214,242,212,244,209,245,207,247,205,247,202,248,200,248,197,248,196,248,192,246,191,245,189,243,187,241,186,239,184,236,183,234,183,231,183,228,183,225,183,222,186,215,187,213,189,209,191,206,194,203,198,201,201,198,203,197,204,195,206,194,207,194,208,193,209,193,210,193,212,193,213,194,214,196,216,197,217,200,220,203,224,209,225,212,228,217,231,222,233,224,234,226,236,229,237,231,239,234,240,236,242,237,243,240,245,242,246,244,247,246,249,247,250,248,252,250,253,251,254,252,255,252,256,252,256,253,257,253} );
    one.learn("medium", new int[] {184,287,184,286,184,285,184,284,184,283,185,282,185,281,185,280,185,279,185,278,186,277,186,275,186,274,187,273,187,271,188,270,188,269,189,267,189,266,189,265,189,264,190,263,190,262,190,261,191,260,191,258,192,257,192,256,192,254,193,251,194,249,195,248,195,246,197,245,197,244,198,242,199,240,199,239,200,237,200,236,201,235,201,233,202,232,203,231,204,229,204,228,204,227,205,225,206,224,206,222,208,221,208,220,209,218,210,217,210,216,211,214,212,213,212,211,213,210,213,209,214,207,215,206,215,205,215,203,215,202,216,201,217,199,217,198,218,197,218,195,219,194,219,193,220,191,220,190,221,188,221,186,222,185,223,183,224,182,224,181,225,179,226,178,226,177,226,176,227,175,227,174,227,173,228,173,228,172,229,171,230,170,231,169,233,169,234,169,235,169,237,169,238,169,239,169,241,169,242,170,243,171,245,173,246,173,248,175,249,176,250,178,252,179,253,180,255,182,255,184,255,185,256,187,256,189,256,191,256,192,256,194,255,196,254,197,252,199,251,200,249,201,248,203,246,204,245,205,244,206,242,207,241,208,240,208,238,208,237,209,236,210,234,211,233,212,231,213,230,213,230,214,229,214,230,215,232,215,233,215,235,217,236,217,237,218,240,220,242,221,244,223,245,224,247,225,248,226,250,228,251,229,252,230,253,230,253,232,254,233,255,234,255,236,255,237,255,238,256,240,256,241,256,242,256,243,256,244,255,246,253,247,253,248,251,250,250,251,249,252,247,253,246,254,244,255,242,256,239,257,235,258,229,259,225,260,219,261,214,261,207,262,200,262,193,262,185,262,178,261,171,260,166,259,163,259,161,259,160,258 } ); 
    one.learn("thick", new int[] {127,172,127,171,128,171,131,172,134,173,138,175,143,177,147,179,151,181,156,184,158,188,161,191,164,195,167,199,170,205,173,210,176,215,178,219,179,222,181,226,182,228,184,230,185,232,185,235,186,238,187,240,188,243,188,246,188,250,189,252,189,255,189,256,189,257,189,258,189,260,189,261,187,263,187,264,185,265,184,268,182,269,181,270,180,272,180,273,179,274,178,274,178,275,177,275,176,275,175,276,175,277,174,277,173,275,172,271,171,265,171,259,171,250,173,242,177,234,181,225,185,217,192,208,198,199,204,193,211,187,215,182,220,178,223,176,224,174,225,173,226,173,227,172,228,171 } );
    one.learn("red", new int[] {182,254,182,253,182,251,182,250,181,248,181,247,180,246,180,244,180,243,180,242,179,240,179,239,178,238,178,236,178,235,178,234,178,233,178,231,178,230,178,229,178,227,177,226,176,225,176,223,176,222,176,220,176,219,176,218,176,217,176,216,176,215,176,213,176,212,176,211,176,210,175,208,175,207,174,205,174,203,174,202,174,201,174,199,174,198,174,197,174,196,173,194,173,193,172,192,172,190,172,189,171,187,170,185,170,184,170,183,170,182,170,180,170,179,170,178,170,176,170,175,170,174,170,173,170,171,170,170,170,168,170,167,170,166,170,164,171,163,171,162,172,160,173,160,174,159,175,158,176,156,177,155,179,153,179,152,181,151,182,150,184,149,184,147,186,147,187,146,188,144,190,144,191,143,193,142,194,142,195,142,197,142,199,142,200,142,201,142,203,142,204,143,206,144,208,146,209,147,211,149,212,150,213,151,214,152,215,153,215,155,216,156,217,157,217,159,217,160,217,161,217,162,217,164,216,165,215,167,213,168,212,170,210,172,209,174,207,175,204,177,201,178,200,180,198,182,195,184,194,185,192,186,191,188,190,189,188,191,187,191,185,192,185,193,184,193,183,193,183,194,182,194,181,194,180,194,179,195,178,196,177,196,176,197,175,198,174,198,176,199,181,201,187,203,192,205,198,207,205,209,211,211,215,213,219,213,221,215,222,216,223,216,224,216,225,217,226,218,227,218,229,219,230,220,231,221,232,221,232,222,233,222 } );
    one.learn("green", new int[] {243,152,242,152,239,152,236,152,233,151,230,150,228,149,227,149,225,149,224,149,223,149,222,149,221,149,220,149,218,149,217,149,216,149,215,149,213,149,212,149,211,149,210,149,209,149,208,149,207,149,206,149,205,149,204,149,202,150,201,150,200,150,199,151,198,151,197,151,197,152,196,152,195,153,194,153,193,153,192,154,191,154,190,155,189,156,188,157,188,158,186,159,186,160,185,161,185,162,183,164,183,165,181,166,181,167,180,168,180,169,179,170,179,171,179,173,179,174,178,176,178,177,178,179,178,180,178,182,178,183,178,184,177,186,177,187,177,189,177,190,177,191,177,192,177,194,177,195,177,196,178,198,178,199,178,200,179,202,180,203,180,204,181,206,181,207,181,208,182,209,182,210,182,211,183,212,184,213,184,214,184,215,186,217,186,218,187,219,188,220,189,220,189,222,190,223,192,224,192,226,194,227,195,228,196,229,197,231,199,232,200,234,201,234,202,235,203,235,205,236,206,237,207,238,208,238,209,239,210,239,211,239,212,239,213,239,214,240,215,240,216,241,218,241,219,241,220,241,222,241,225,241,226,241,227,241,228,241,229,241,230,241,231,241,232,241,233,241,235,240,236,239,237,239,239,238,240,237,241,236,243,235,244,235,244,234,245,233,246,232,247,231,248,230,248,228,249,227,249,226,249,224,249,223,250,222,250,221,250,219,250,218,250,217,250,215,250,214,250,213,250,211,250,210,249,208,249,207,249,206,249,204,249,203,249,201,249,200,249,199,249,198,249,197,249,196,249,195,249,194,250,194,251,194,252,194,252,193,253,193,254,193,255,193,256,193,258,193,259,193,260,193,262,193,263,193,265,193,266,193,268,193,269,193,270,193,271,193,272,193,273,193,274,193,275,193,276,193,277,193,278,193,279,193,280,193,281,193,282,193,283,193,284,193,284,194,284,195,284,196,284,198,284,199,284,200,284,202,284,203,284,204,284,206,284,207,284,208,284,209,285,211,285,212,286,214,287,215,288,216,289,218,290,219,291,220,292,222,294,223,295,225,296,225,297,227,299,227,299,228,300,229,301,230,302,232,303,232,303,233,304,234,305,235,306,236,307,237,307,238,309,238,310,240,311,240 } );
    one.learn("blue", new int[] {225,133,226,138,227,146,229,155,230,163,231,172,232,182,234,190,235,198,237,208,239,216,241,226,242,234,242,240,243,246,243,253,244,258,245,261,245,264,245,265,245,266,245,267,245,266,245,265,245,264,245,263,245,261,244,260,244,258,244,256,244,254,244,253,244,252,244,251,244,249,244,248,245,246,246,244,248,242,249,241,250,240,251,239,252,237,252,236,254,235,255,233,257,232,258,231,259,230,261,230,262,230,263,230,266,231,268,232,272,233,274,235,276,236,279,238,281,239,282,241,284,242,285,244,287,245,288,246,289,247,289,248,289,250,289,251,289,252,289,253,289,255,287,258,286,261,284,265,282,268,280,271,278,273,274,274,269,276,263,278,257,280,253,281,247,283,245,283,244,283,243,283,242,283,242,282 } );
    one.learn("black", new int[] {161,169,164,169,168,169,171,169,175,168,177,167,179,167,181,166,182,165,183,165,185,165,186,165,187,165,188,165,190,165,191,165,192,165,194,165,195,165,196,165,197,165,199,165,200,165,201,165,202,165,204,165,205,165,206,165,207,165,208,165,210,165,211,165,212,165,214,165,215,165,216,165,217,165,218,165,219,165,220,165,221,165,222,165,223,165,224,165,225,165,226,165,226,164,227,164,228,164,229,164,230,164,231,164,232,164,233,164,234,164,235,164,236,164,238,164,239,164,240,164,241,164,242,164,243,164,244,164,245,164,246,164,247,164,248,164,250,164,251,164,252,164,253,164,255,164,256,164,257,164,257,165,257,166,256,167,256,168,256,169,256,170,255,170,255,172,254,173,253,174,252,176,250,177,249,179,248,180,246,181,245,183,243,184,242,185,240,186,240,188,239,188,238,190,237,191,235,193,234,194,232,195,231,196,230,197,228,198,227,199,225,200,225,201,223,202,223,203,222,203,220,204,219,205,217,206,216,208,215,208,214,209,212,210,212,211,210,212,209,213,207,214,207,215,206,215,206,216,205,216,204,218,203,218,202,218,201,219,200,219,199,220,198,221,196,221,195,222,193,223,192,224,191,224,189,225,188,225,186,226,185,227,184,227,182,228,180,230,179,230,178,230,177,232,176,232,174,233,173,234,171,235,169,236,168,236,167,237,167,238,166,238,167,238,168,238,169,238,171,238,172,238,173,238,175,239,176,239,177,239,179,239,180,240,181,240,183,241,184,241,185,241,186,241,188,241,189,241,190,242,192,243,193,243,194,244,197,244,198,244,199,244,201,245,202,245,204,245,205,246,206,246,208,246,209,246,210,246,211,246,213,246,214,246,215,246,217,246,218,246,219,246,220,246,222,246,223,246,224,246,225,246,226,246,227,246,229,246,230,246,231,246,234,245,235,244,236,244,238,244,239,243,240,242,242,242,243,242,244,241,246,240,247,240,248,240,250,239,251,239,252,239,253,238,254,238,255,238,257,237,258,237,259,237,260,237,262,237,263,237,264,236,266,236,267,236,268,236,269,236,270,236,271,236,272,236 } );
  
    // 3. Bind templates to methods (callbacks):
    one.bind("ellipse freel straightl rectangle thin medium thick red green blue black", "detected");
}

/* Implement OD callbacks
*/
void detected(String gesture, float percent, int startX, int startY, int centroidX, int centroidY, int endX, int endY){
  println("Gesture: "+gesture+", "+startX+"/"+startY+", "+centroidX+"/"+centroidY+", "+endX+"/"+endY);
  gesture_name = gesture;
}
