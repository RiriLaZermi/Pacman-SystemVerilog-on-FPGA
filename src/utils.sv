package utils;
  typedef enum logic [2:0] {
    RIGHT = 3'b000,
    LEFT  = 3'b001,
    UP    = 3'b010,
    DOWN  = 3'b011,
    IDLE  = 3'b111
  } direction_t;
  
typedef enum logic [11:0] {
    BLACK   = 12'b0000_0000_0000, // Noir (R:0000, G:0000, B:0000)
    RED     = 12'b1111_0000_0000, // Rouge (R:1111, G:0000, B:0000)
    GREEN   = 12'b0000_1111_0000, // Vert (R:0000, G:1111, B:0000)
    BLUE    = 12'b0000_0000_1111, // Bleu (R:0000, G:0000, B:1111)
    YELLOW  = 12'b1111_1111_0000, // Jaune (R:1111, G:1111, B:0000)
    CYAN    = 12'b0000_1111_1111, // Cyan (R:0000, G:1111, B:1111)
    MAGENTA = 12'b1111_0000_1111, // Magenta (R:1111, G:0000, B:1111)
    WHITE   = 12'b1111_1111_1111, // Blanc (R:1111, G:1111, B:1111)
    PINK    = 12'b1111_1100_1100,  // Rose (R:1111, G:1100, B:1100)
    BEIGE = 12'b1110_1101_1010,  // Plus beige (R:1110, G:1101, B:1010)
    ORANGE = 12'b1111_0110_0010  // (R:1110, G:1011, B:1001)
} color_t;

typedef enum logic[1:0] {
    CHASE, 
    SCATTER, 
    AFFRAID, 
    EATEN} ghost_modes_t;

endpackage
