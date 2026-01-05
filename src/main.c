#include <stdlib.h>
#include <graphics/drawing.h>
#include <graphics/color.h>
#include <graphics/text.h>
#include <graphics/lcdc.h>
#include <sh4a/input/keypad.h>

int main(void) {
  set_pen(create_rgb16(0, 0, 0));
  draw_rect(0, 0, 528, 320);
  set_pen(create_rgb16(255, 255, 255));
  render_text(0, 0, "Hello, world!");
  lcdc_copy_vram();
  
  while (1) {
    keypad_read();
    if (get_key_state(KEY_POWER) || get_key_state(KEY_BACK)) exit(-2);
  }
}
