module controller(clk, start, reset, is_goal, is_wall, end_loop, main_empty, temp_empty, run, empty_queue, clr_x, clr_y, temp_clear, main_clear, queue_clear, clr_cnt, Din, wr, rd, load_x, load_y, main_push, cnt_en, fail, sel_reverse, main_pop, load_cnt, temp_push, enqueue, temp_pop, dequeue, done, end_iteration , clr_cnt2, cnt2_en,sel_queue);
    input clk, start, reset, is_goal, is_wall, end_loop, main_empty, temp_empty, run, empty_queue, end_iteration;
    output reg clr_x, clr_y, temp_clear, main_clear, queue_clear,
     clr_cnt, Din, wr, rd, load_x, load_y, main_push, cnt_en, fail, sel_reverse,
    main_pop, load_cnt, temp_push, enqueue, temp_pop,
    dequeue, done, clr_cnt2, cnt2_en,sel_queue;  
    parameter [4:0] IDLE = 5'd0, INIT = 5'd1, BLOCK_CURRENT_POSTION = 5'd2, CHECK_DIRECTION = 5'd3,
    MOVE_FORWARD = 5'd4, RESET_DIRECTION = 5'd5, CHANGE_DIRECTION = 5'd6, READY_DIRECTION = 5'd7, 
    BACKTRACK = 5'd8, FAIL = 5'd9, GO_BACK = 5'd10, POP_LAST_MOVE = 5'd11, LOAD_LAST_DIRECTION = 5'd12, 
    NEW_DIRECTION = 5'd13, PUSH_TEMP_STACK = 5'd14, POP_MAIN_STACK = 5'd15, PUSH_QUEUE = 5'd16, POP_TEMP_STACK = 5'd17,
    WAIT_FOR_RUN = 5'd18, SHOW_OUT_PUT = 5'd19, CHECK_END_OF_ITERATION = 5'd20, POP_QUEUE = 5'd21; 
    reg [4:0] ps, ns; 
    always @(ps, start, is_goal, is_wall, end_loop, main_empty, end_iteration, temp_empty, run) begin
        ns = IDLE; 
        case (ps)
            IDLE: ns = (start ? INIT : IDLE); 
            INIT: ns = BLOCK_CURRENT_POSTION; 
            BLOCK_CURRENT_POSTION: ns = (is_goal ? PUSH_TEMP_STACK : CHECK_DIRECTION); 
            CHECK_DIRECTION: ns = (is_wall ? CHANGE_DIRECTION : MOVE_FORWARD); 
            MOVE_FORWARD: ns = RESET_DIRECTION; 
            RESET_DIRECTION: ns = BLOCK_CURRENT_POSTION; 
            CHANGE_DIRECTION: ns = READY_DIRECTION; 
            READY_DIRECTION: ns = (end_loop ? BACKTRACK : CHECK_DIRECTION); 
            BACKTRACK: ns = (main_empty ? FAIL : GO_BACK); 
            FAIL: ns = IDLE;
            GO_BACK: ns = LOAD_LAST_DIRECTION; 
            POP_LAST_MOVE: ns = NEW_DIRECTION; 
            LOAD_LAST_DIRECTION: ns = POP_LAST_MOVE;     
            NEW_DIRECTION: ns = CHECK_DIRECTION; 
            PUSH_TEMP_STACK: ns = POP_MAIN_STACK; 
            POP_MAIN_STACK: ns = (main_empty ? PUSH_QUEUE : PUSH_TEMP_STACK); 
            PUSH_QUEUE: ns = POP_TEMP_STACK; 
            POP_TEMP_STACK: ns = (temp_empty ? WAIT_FOR_RUN : PUSH_QUEUE); 
            WAIT_FOR_RUN: ns = (run ? SHOW_OUT_PUT : WAIT_FOR_RUN);
            SHOW_OUT_PUT: ns = POP_QUEUE; 
            POP_QUEUE: ns = CHECK_END_OF_ITERATION;
            CHECK_END_OF_ITERATION: ns = (end_iteration ? WAIT_FOR_RUN : SHOW_OUT_PUT); 
        endcase
    end
    always @(posedge clk, posedge reset) begin
        if (reset == 1'b1)
            ps <= IDLE;
        else 
            ps <= ns; 
    end
    always @(ps, start) begin
        {clr_x, clr_y, temp_clear, main_clear, queue_clear, clr_cnt} = 6'b000000; 
        {Din, wr} = 2'b00; rd = 1'b0; 
        {load_x, load_y, main_push} = 3'b000;
        cnt_en = 1'b0; fail = 1'b0; sel_reverse = 1'b0; 
        main_pop = 1'b0; load_cnt = 1'b0; temp_push = 1'b0; 
        enqueue = 1'b0; temp_pop = 1'b0; dequeue = 1'b0; 
        done = 1'b0; clr_cnt2 = 1'b0; cnt2_en = 1'b0;sel_queue=1'b0; 
        case (ps)
            IDLE: begin {clr_x, clr_y, temp_clear, main_clear, queue_clear, clr_cnt} = 6'b111111; end
            INIT: begin {clr_x, clr_y, temp_clear, main_clear, queue_clear, clr_cnt} = 6'b111111; end
            BLOCK_CURRENT_POSTION: begin {Din, wr} = 2'b11; end
            CHECK_DIRECTION: rd = 1'b1;
            MOVE_FORWARD: {load_x, load_y, main_push} = 3'b111;
            RESET_DIRECTION: clr_cnt = 1'b1;
            CHANGE_DIRECTION: cnt_en = 1'b1;
            FAIL: fail = 1'b1;
            GO_BACK: {load_x, load_y, sel_reverse} = 3'b111;
            POP_LAST_MOVE: main_pop = 1'b1;
            LOAD_LAST_DIRECTION: load_cnt = 1'b1;
            NEW_DIRECTION: cnt_en = 1'b1; 
            PUSH_TEMP_STACK: temp_push = 1'b1; 
            POP_MAIN_STACK: main_pop = 1'b1; 
            PUSH_QUEUE: enqueue = 1'b1; 
            POP_TEMP_STACK: temp_pop =1'b11;
            WAIT_FOR_RUN: {clr_cnt2, done} = 2'b11; 
            SHOW_OUT_PUT: {cnt2_en, done, enqueue,sel_queue} = 4'b1111; 
            POP_QUEUE: {dequeue, done} = 2'b11; 
            CHECK_END_OF_ITERATION: done = 1'b1;  
        endcase
    end
endmodule