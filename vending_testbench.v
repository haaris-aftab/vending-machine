//
// Module: vending_machine_tb.v
// Description: A self-checking testbench for the vending machine module.
// It includes directed tests for common scenarios and reports success or failure.
//

`timescale 1ns / 1ps

module vending_machine_tb;

    // Parameters
    localparam PRICE = 100;

    // Inputs
    reg clk;
    reg rst_n;
    reg in_coin_5;
    reg in_coin_10;
    reg in_coin_25;

    // Outputs
    wire       product_dispense;
    wire [7:0] change_out;
    wire [7:0] current_balance;

    // Instantiate the Unit Under Test (UUT)
    vending_machine #(
        .PRICE(PRICE)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .in_coin_5(in_coin_5),
        .in_coin_10(in_coin_10),
        .in_coin_25(in_coin_25),
        .product_dispense(product_dispense),
        .change_out(change_out),
        .current_balance(current_balance)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test Sequence
    initial begin
        $display("----------------------------------------------------");
        $display("Starting Vending Machine Testbench");
        $display("Item Price: %0d cents", PRICE);
        $display("----------------------------------------------------");

        // Initialize and reset
        rst_n = 0;
        in_coin_5 = 0;
        in_coin_10 = 0;
        in_coin_25 = 0;
        #20;
        rst_n = 1;
        #10;

        // --- Test Case 1: Exact Change ---
        $display("\n[Test Case 1] Paying exact amount (4 x 25c)");
        insert_coin(25);
        insert_coin(25);
        insert_coin(25);
        insert_coin(25);
        
        wait_for_dispense();
        check_change(0);
        
        // --- Test Case 2: Overpayment ---
        $display("\n[Test Case 2] Overpaying (3 x 25c + 2 x 10c + 2 x 5c = 105c)");
        insert_coin(25);
        insert_coin(25);
        insert_coin(25);
        insert_coin(10);
        insert_coin(10);
        insert_coin(5);
        insert_coin(5);

        wait_for_dispense();
        check_change(105 - PRICE);

        // --- Test Case 3: Insufficient Funds then Add More ---
        $display("\n[Test Case 3] Insufficient funds, then adding more");
        insert_coin(25);
        insert_coin(25);
        $display("  Current balance: %0d. Not enough yet.", current_balance);
        #50; // Wait a bit
        insert_coin(25);
        insert_coin(25);

        wait_for_dispense();
        check_change(0);

        // --- Test Case 4: Reset during transaction ---
        $display("\n[Test Case 4] Reset during transaction");
        insert_coin(10);
        insert_coin(10);
        #10;
        $display("  Applying reset...");
        rst_n = 0;
        #20;
        rst_n = 1;
        #10;
        if (current_balance == 0) begin
            $display("  SUCCESS: Balance correctly reset to 0.");
        end else begin
            $display("  FAILURE: Balance is %0d, should be 0.", current_balance);
        end


        $display("\n----------------------------------------------------");
        $display("All test cases finished.");
        $display("----------------------------------------------------");
        $finish;
    end

    // Task to simulate inserting a coin
    task insert_coin(input [7:0] coin_value);
        begin
            @(negedge clk);
            case (coin_value)
                5:   in_coin_5  = 1;
                10:  in_coin_10 = 1;
                25:  in_coin_25 = 1;
                default: $display("Invalid coin value in test.");
            endcase
            $display("  Inserted %0d cents. Current balance: %0d", coin_value, current_balance);
            @(negedge clk);
            in_coin_5  = 0;
            in_coin_10 = 0;
            in_coin_25 = 0;
            #2; // Wait for signals to settle
        end
    endtask

    // Task to wait for the dispense signal
    task wait_for_dispense;
        begin
            @(posedge product_dispense);
            $display("  SUCCESS: Product dispensed.");
            @(negedge clk);
        end
    endtask

    // Task to check if the change is correct
    task check_change(input [7:0] expected_change);
        begin
            // Wait for the change state
            while (change_out == 0 && current_balance != 0) begin
                @(posedge clk);
            end
            
            if (change_out == expected_change) begin
                $display("  SUCCESS: Change is correct (%0d cents).", change_out);
            end else begin
                $display("  FAILURE: Change is %0d, expected %0d.", change_out, expected_change);
            end
            
            // Wait until state machine is idle again
            while (current_balance != 0) begin
                @(posedge clk);
            end
        end
    endtask

endmodule
