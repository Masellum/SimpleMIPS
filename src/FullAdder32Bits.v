module oneBitAdder(
    a, b, carryIn, carryOut, sum
);
    input a, b, carryIn;
    output carryOut, sum;
    wire carryOut, sum;
    assign sum = a ^ b ^ carryIn;
    assign carryOut = (b & carryIn) | (a & carryIn) | (a & b);
endmodule

module oneBitALU (
    a, b, carryIn, carryOut, Operation, Ainvert, Binvert, Less, Result
);
    input a, b, carryIn, Ainvert, Binvert, Less;
    input [1:0] Operation;
    output carryOut, Result;
    reg Result;
    wire tempA, tempB, tempResultForAdder/*, less*/;

    assign tempA = (Ainvert == 1) ? ~a : a;
    assign tempB = (Binvert == 1) ? ~b : b;

    always @(tempA, tempB, tempResultForAdder, Less, Operation) begin
        case (Operation)
            2'b00: Result = tempA & tempB;
            2'b01: Result = tempA | tempB;
            2'b10: Result = tempResultForAdder;
            2'b11: Result = Less;
            default: Result = 1'bz;
        endcase
    end

    oneBitAdder adder (
        .a (tempA),
        .b (tempB),
        .carryIn (carryIn),
        .carryOut (carryOut),
        .sum (tempResultForAdder)
    );
endmodule

module oneBitALUForMSB (
    a, b, carryIn, Operation, Ainvert, Binvert, Less, Result, Set, Overflow
);
    input a, b, carryIn, Less, Ainvert, Binvert;
    input [1:0] Operation;
    output Result, Set, Overflow;
    reg Result;
    wire tempA, tempB, Set, tempResultForAdder, rresult, carryOut;

    assign tempA = (Ainvert == 1) ? ~a : a;
    assign tempB = (Binvert == 1) ? ~b : b;
    assign Overflow = carryIn ^ carryOut;
    assign Set = tempResultForAdder;

    always @(tempA, tempB, tempResultForAdder, Less, Operation) begin
        case (Operation)
            2'b00: Result = tempA & tempB;
            2'b01: Result = tempA | tempB;
            2'b10: Result = tempResultForAdder;
            2'b11: Result = Less;
            default: Result = 1'bz;
        endcase
    end
    oneBitAdder adder (
        .a (tempA),
        .b (tempB),
        .carryIn (carryIn),
        .carryOut (carryOut),
        .sum (tempResultForAdder)
    );
endmodule

module FullAdder32Bits (
    a, b, Operation, Anegate, Bnegate, Signed, Carry, Result, Zero, Overflow
);
    input [31:0] a, b;
    input [1:0] Operation;
    input Anegate, Bnegate, Signed;
    input Carry;

    output [31:0] Result;
    output Overflow, Zero;

    wire [31:0] conn;
    wire set, realSet;

    assign Zero = ~(|Result);
    assign realSet = Signed ? (set ^ Overflow) : (((a[31]) & ~b[31]) | (~(a[31] ^ b[31]) & set));

    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin:loop_gen_block
            if (i == 0) begin
                oneBitALU obALU(
                    .a(a[i]),
                    .b(b[i]),
                    .carryIn(Anegate | Bnegate),
                    .carryOut(conn[i]),
                    .Operation(Operation),
                    .Ainvert(Anegate),
                    .Binvert(Bnegate),
                    .Less(realSet),
                    .Result(Result[i])
                );
            end else if (i < 31) begin
                oneBitALU obALU(
                    .a(a[i]),
                    .b(b[i]),
                    .carryIn(Carry ? conn[i - 1] : 1'b0),
                    .carryOut(conn[i]),
                    .Operation(Operation),
                    .Ainvert(Anegate),
                    .Binvert(Bnegate),
                    .Less(1'b0),
                    .Result(Result[i])
                );
            end else begin
                oneBitALUForMSB obALUForMSB(
                    .a(a[i]),
                    .b(b[i]),
                    .carryIn(Carry ? conn[i - 1] : 1'b0),
                    .Operation(Operation),
                    .Ainvert(Anegate),
                    .Binvert(Bnegate),
                    .Less(1'b0),
                    .Result(Result[i]),
                    .Set(set),
                    .Overflow(Overflow)
                );
            end
        end
    endgenerate
endmodule