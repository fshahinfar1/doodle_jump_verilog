/*
* This is the main board of our arcade game
* */
module GameBox (screen, left, right, clk, reset);

localparam countPulseBeforePhysicsUpdate=100;
localparam SCR_W=400;
localparam SCR_H=700;
localparam BLK_W=40;
localparam BLK_H=5;
localparam MAX_JMP_H=80;
localparam BLOCK_IN_WIDTH = SCR_W / BLK_W;
localparam BLOCK_IN_HEIGHT = SCR_H / BLK_H;

input left, right, clk, reset;
reg _left, _right, _clk, _reset;

// screen
output reg [23:0][SCREEN_WIDTH - 1: 0] screen [SCREEN_HEIGHT - 1: 0]; // r,g,b (8bit, 8bit, 8bit)
wire [23:0][SCREEN_WIDTH - 1: 0] _screen [SCREEN_HEIGHT - 1: 0]; // r,g,b (8bit, 8bit, 8bit)

RenderBox _renderBox #(SCR_W, SCR_H, BLK_W, BLK_H)
			(_screen, doodleX, doodleY, blocksX, blocksY);

// create physics clk
reg physicsUpdate;
reg [31:0] pulsCounter;
always @(posedge clk)
begin
	pulsCounter = pulsCounter + 1;
	if (pulsCounter == countPulseBeforePhysicsUpdate)
	begin
		pulsCounter = 0;
		physicsUpdate = ~physicsUpdate;
	end
end

// doodle manager
reg hasCollide; //TODO: make has collide
wire [31:0] _doodleX, _doodleY;
reg [31:0] doodleX, doodleY;
DoodleManager _doodleMan #(SCR_W, SCR_H, BLK_W, BLK_H, MAX_JMP_H)
				(_doodleX, _doodleY, _left, _right, hasCollide 
					_clk, physicsUpdate, _reset);

// blocks manager
wire [31:0][BLOCK_IN_WIDTH - 1: 0] _blocksX [BLOCK_IN_HEIGHT - 1:0];
wire [31:0][BLOCK_IN_WIDTH - 1: 0] _blocksY [BLOCK_IN_HEIGHT - 1:0];
wire [BLOCK_IN_WIDTH - 1: 0] _isBlockActive [BLOCK_IN_HEIGHT - 1:0];;
reg [31:0][BLOCK_IN_WIDTH - 1: 0] blocksX [BLOCK_IN_HEIGHT - 1:0];
reg [31:0][BLOCK_IN_WIDTH - 1: 0] blocksY [BLOCK_IN_HEIGHT - 1:0];
reg [BLOCK_IN_WIDTH - 1: 0] isBlockActive [BLOCK_IN_HEIGHT - 1:0];
BlockManager _blockMan #(SCR_W, SCR_H, BLK_W, BLK_H)
			(_blocksX, _blocksY, isBlockActive, newView, minY,
			collisionX, collisionY, hasCollide, _reset);

// view manager
wire _minYCrossed, _newView;
wire [31: 0] _minY;
reg newView;
reg [31: 0] minY;
ViewManager _viewMan #(SCR_W, SCR_H, BLK_W, BLK_H)
			(_minYCrossed, _newView, _minY, doodleY, _reset);

// collision detector
wire _hasCollide;
wire [31: 0] _collisionX, _collisionY;
reg hasCollide;
reg [31 : 0] collisionX, collisionY;
Collisiondetector _collisionDetector #(SCR_W, SCR_H, BLK_W, BLK_H)
			(_collisionX, _collisionY, _hasCollide, doodleX, doodleY,
			blocksX, blocksY, isBlockActive);

// connect wires and registers
always @(_screen, left, right, reset, clk,
	_doodleX, _doodleY, _blocksX, _blocksY,
	_newView, _minY, _collisionX, _collisionY)
begin
	screen = _screen;

	_left = left;
	_right = right;
	_reset = reste;
	_clk = clk;

	doodleX = _doodleX;
	doodleY = _doodleY;

	blocksX = _blocksX;
	blocksY = _blocksY;

	minY = _minY;
	newView = _newView;

	collisionX = _collisionX;
	collisionY = _collisionY;
	hasCollide = _hasCollide;

end
endmodule
