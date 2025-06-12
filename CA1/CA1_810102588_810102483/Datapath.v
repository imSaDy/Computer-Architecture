module datapath(
    input clk,
    input rst,
    input cnt_en,
    input load_count,
    input clr_cnt,
    input clr_x,
    input clr_y,
    input load_x,
    input load_y,
    input rd,
    input sel_reverse,
    output wire [3:0] memory_x_input,
    output wire [3:0] memory_y_input,
    input main_clear,
    input main_push,
    input main_pop,
    output main_empty,
    input temp_clear,
    input temp_pop,
    input temp_push,
    output temp_empty,
    input Dout,
    input sel_queue,
    input clr_cnt2,
    input cnt2_en,
    output wire is_goal,
    
    output invalid_move, 
    input main_queue_clr,
    input main_enqueue,
    input main_dequeue,
    output main_queue_empty,
    output wire[1:0] front_main_queue,
    output end_loop,
    output end_iteration
    );
    wire signed [2:0] dir;
    wire signed [1:0] main_top;
    Counter  #(.SIZE(3))C1(
        .clk(clk),
        .rst(clr_cnt),
        .cnt_en(cnt_en),
        .ld_en(load_count),
        .ld({1'b0,main_top}),
        .out(dir)
    );
    and SignDirection (end_loop,1,dir[2]);
    wire [3:0] x,y;
    wire [3:0] new_x,new_y;
    
    Register  #(.SIZE(4)) Regx(
        .clk(clk),
        .rst(clr_x),
        .enable(load_x),
        .data_in(new_x),
        .data_out(x)   
    );
    Register  #(.SIZE(4))Regy(
        .clk(clk),
        .rst(clr_y),
        .enable(load_y),
        .data_in(new_y),  
        .data_out(y) 
    );
    wire [3:0] dx,dy;
    Adder  #(.SIZE(4)) NewPosCalculatorX(
        .a(x),
        .b(dx),
        .sum(new_x)
    );
    Adder  #(.SIZE(4)) NewPosCalculatorY(
        .a(y),
        .b(dy),
        .sum(new_y)
    );
    
    assign is_goal = &x & &y;
    mux  #(.SIZE(4),.NUM_INPUTS(2)) selectMemoryX 
    (
        .inputs({new_x,x}),
        .sel(rd),
        .out(memory_x_input)
    );
    mux  #(.SIZE(4),.NUM_INPUTS(2)) selectMemoryY 
    (
        .inputs({new_y,y}),
        .sel(rd),
        .out(memory_y_input)
    );
    wire[2:0] sel_dir;
    mux #(.SIZE(4),.NUM_INPUTS(4)) dx_selector
    (
        .inputs({4'b0000,4'b1111,4'b0001,4'b0000}),
        .sel(sel_dir[1:0]),
        .out(dx)
    );
    mux #(.SIZE(4),.NUM_INPUTS(4)) dy_selector
    (
        .inputs({4'b0001,4'b0000,4'b0000,4'b1111}),
        .sel(sel_dir[1:0]),
        .out(dy)
    );
    mux  #(.SIZE(3),.NUM_INPUTS(2)) Sel_dfs_mode 
    (
        .inputs({3'b011-main_top,dir}),
        .sel(sel_reverse),
        .out(sel_dir)
    );
    stack main_stack
    (
        .clk(clk),
        .rst(main_clear),
        .push(main_push),
        .pop(main_pop),
        .data_in(dir[1:0]),
        .data_out(main_top[1:0]),
        .empty(main_empty) 
    );
    wire [1:0] temp_top;
    stack temp_stack
    (
        .clk(clk),
        .rst(temp_clear),
        .push(temp_push),
        .pop(temp_pop),
        .data_in(main_top),
        .data_out(temp_top),
        .empty(temp_empty)
    );
    wire invalid_right,invalid_left,invalid_up,invalid_down;
    assign invalid_right = (x == 4'b1111) && (new_x==4'b0000);
    assign invalid_left = (x == 4'b0000) && (new_x==4'b1111);
    assign invalid_up = (y == 4'b1111) && (new_y==4'b0000);
    assign invalid_down = (y == 4'b0000) && (new_y==4'b1111);  
    wire outof_bounds;
    or bound_check (outof_bounds,invalid_right,invalid_left,invalid_up,invalid_down);  
    or invalid_move_check (invalid_move,Dout,outof_bounds);
    wire main_queue_full;
    wire [7:0] queue_size;
    wire[1:0] main_queue_data_in;
    queue main_queue
    (
        .clk(clk),
        .rst(main_queue_clr),
        .enqueue(main_enqueue),
        .dequeue(main_dequeue),
        .data_in(main_queue_data_in),
        .data_out(front_main_queue),
        .empty(main_queue_empty),
        .full(main_queue_full),
        .size(queue_size)
    );
    mux #(.SIZE(2),.NUM_INPUTS(2))
    select_main_queue_input 
    (
        .inputs({front_main_queue,temp_top}),
        .sel(sel_queue),
        .out(main_queue_data_in)
    );
    wire [7:0]count;
    
    Counter  #(.SIZE(8)) C2
    (
        .clk(clk),
        .rst(clr_cnt2),
        .cnt_en(cnt2_en),
        .ld_en(1'b0),
        .ld(8'b0),
        .out(count)
    );
    assign end_iteration= (count == queue_size);
endmodule