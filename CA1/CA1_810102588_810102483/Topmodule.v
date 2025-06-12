
module topmodule(
    input clk,
    input load_memory,
    input reset,
    input start,
    input run,
    input Dout,
    output done,
    output fail,
    output wire [1:0] move,
    output end_iteration,
    output rd,
    output wr, 
    output wire [3:0] memory_x_input,
    output wire [3:0] memory_y_input,
    output Din
);

    wire clr_x, clr_y,temp_clear, main_clear, queue_clear, queue2_clear, clr_cnt,is_wall;
    wire load_x, load_y, main_push, cnt_en, sel_reverse, main_pop, load_cnt;
    wire temp_push, enqueue, temp_pop, dequeue, enqueue2, dequeue2, empty_queue;
    wire main_empty, temp_empty, is_goal;
    wire sel_queue,clr_cnt2,cnt2_en;
    wire end_loop;
    
    controller ctrl(
        .clk(clk),
        .start(start),
        .reset(reset),
        .is_goal(is_goal),
        .is_wall(is_wall),
        .end_loop(end_loop), 
        .main_empty(main_empty),
        .temp_empty(temp_empty),
        .run(run),
        .empty_queue(empty_queue),
        .clr_x(clr_x),
        .clr_y(clr_y),
        .temp_clear(temp_clear),
        .main_clear(main_clear),
        .queue_clear(queue_clear),
        .clr_cnt(clr_cnt),
        .Din(Din),
        .wr(wr),
        .rd(rd),
        .load_x(load_x),
        .load_y(load_y),
        .main_push(main_push),
        .cnt_en(cnt_en),
        .fail(fail),
        .sel_reverse(sel_reverse),
        .main_pop(main_pop),
        .load_cnt(load_cnt),
        .temp_push(temp_push),
        .enqueue(enqueue),
        .temp_pop(temp_pop),
        .dequeue(dequeue),
        .done(done),
        .clr_cnt2(clr_cnt2),
        .cnt2_en(cnt2_en),
        .sel_queue(sel_queue),
        .end_iteration(end_iteration)
    );

    datapath dp(
        .clk(clk),
        .rst(reset),
        .cnt_en(cnt_en),
        .load_count(load_cnt),
        .clr_cnt(clr_cnt),
        .clr_x(clr_x),
        .clr_y(clr_y),
        .load_x(load_x),
        .load_y(load_y),
        .rd(rd),
        .sel_reverse(sel_reverse),
        .memory_x_input(memory_x_input),
        .memory_y_input(memory_y_input),
        .main_clear(main_clear),
        .main_push(main_push),
        .main_pop(main_pop),
        .main_empty(main_empty),
        .temp_clear(temp_clear),
        .temp_pop(temp_pop),
        .temp_push(temp_push),
        .temp_empty(temp_empty),
        .invalid_move(is_wall), 
        .main_queue_clr(queue_clear),
        .main_enqueue(enqueue),
        .main_dequeue(dequeue),
        .main_queue_empty(empty_queue),
        .front_main_queue(move),
        .end_loop(end_loop),
        .Dout(Dout),
        .is_goal(is_goal),
        .sel_queue(sel_queue),
        .clr_cnt2(clr_cnt2),
        .cnt2_en(cnt2_en),
        .end_iteration(end_iteration)

    );
    queue_logger logger (
        .clk(clk),
        .dequeue(dequeue),
        .queue_data(move)
    );

endmodule