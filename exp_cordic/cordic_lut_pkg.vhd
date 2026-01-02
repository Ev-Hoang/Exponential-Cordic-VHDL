library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

package cordic_lut_pkg is

    type seq_array is array (0 to N_ITER) of integer;
    constant SEQ_ROM : seq_array := (
        1,2,3,4,4,5,6,7,7,8,
        9,10,10,11,12,13,13,14,15,16,
        16,17,18,19,19,20,21,22,22,23,24
    );

type lut_array is array (0 to N_ITER) of q2_24;
constant ATANH_LUT : lut_array := (
    to_signed(integer(0.549306000 * 2.0**24), 26), --1
    to_signed(integer(0.255413000 * 2.0**24), 26), --2
    to_signed(integer(0.125657000 * 2.0**24), 26), --3
    to_signed(integer(0.062581600 * 2.0**24), 26), --4
    to_signed(integer(0.062581600 * 2.0**24), 26), --4
    to_signed(integer(0.031260200 * 2.0**24), 26), --5
    to_signed(integer(0.015626300 * 2.0**24), 26), --6
    to_signed(integer(0.007812660 * 2.0**24), 26), --7
    to_signed(integer(0.007812660 * 2.0**24), 26), --7
    to_signed(integer(0.003906270 * 2.0**24), 26), --
    to_signed(integer(0.001953130 * 2.0**24), 26), --
    to_signed(integer(0.000976563 * 2.0**24), 26), --10
    to_signed(integer(0.000976563 * 2.0**24), 26), --10
    to_signed(integer(0.000488281 * 2.0**24), 26), --
    to_signed(integer(0.000244141 * 2.0**24), 26), --
    to_signed(integer(0.000122070 * 2.0**24), 26), --13
    to_signed(integer(0.000122070 * 2.0**24), 26), --13
    to_signed(integer(0.000061035 * 2.0**24), 26), --
    to_signed(integer(0.000030517 * 2.0**24), 26), --
    to_signed(integer(0.000015258 * 2.0**24), 26), --16
    to_signed(integer(0.000015258 * 2.0**24), 26), --16
    to_signed(integer(0.000007629 * 2.0**24), 26), --
    to_signed(integer(0.000003814 * 2.0**24), 26), --
    to_signed(integer(0.000001907 * 2.0**24), 26), --19
    to_signed(integer(0.000001907 * 2.0**24), 26), --19
    to_signed(integer(0.000000953 * 2.0**24), 26), --
    to_signed(integer(0.000000476 * 2.0**24), 26), --
    others => to_signed(0,26)
);

end package;

