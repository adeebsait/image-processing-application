class DrawnShape {
  public int x, y, w, h;
  public PGraphics newg, oldg, filtg;
  public String tag;
  public DrawnShape(int x, int y, int w, int h, PGraphics g, String tag) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.newg = g;
    this.oldg = g;
    this.filtg = g;
    this.tag = tag;
  }
  public boolean posIn(float px, float py) {
    return !(px < x || px > x + w || py < y || py > y + h);
  }
}
