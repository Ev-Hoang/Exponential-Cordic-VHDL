library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity cordic_top is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;

        z_in     : in  q8_24;

        y_out    : out q8_24;
        done     : out std_logic;

        -- debug 
        x_test   : out q8_24;
        y_test   : out q8_24;
        z_test   : out q8_24;
        r_test   : out q8_24;
        k_test   : out integer;

        rang     : out std_logic;
    	init     : out std_logic;
    	cordic   : out std_logic;
    	result   : out std_logic;

        iter_test: out integer range 0 to N_ITER
    );
end entity;

architecture rtl of cordic_top is

    signal en_range  : std_logic;
    signal en_init   : std_logic;
    signal en_cordic : std_logic;
    signal en_result : std_logic;

    signal iter      : integer range 0 to N_ITER;

    signal done_dp   : std_logic;

begin

    ------------------------------------------------------------------
    -- CONTROLLER
    ------------------------------------------------------------------
    u_ctrl : entity work.cordic_controller
        port map (
            clk       => clk,
            rst       => rst,
            start     => start,

            iter      => iter,
            done_dp   => done_dp,

            en_range  => en_range,
            en_init   => en_init,
            en_cordic => en_cordic,
            en_result => en_result,

            done      => done
        );

    ------------------------------------------------------------------
    -- DATAPATH
    ------------------------------------------------------------------
    u_dp : entity work.cordic_datapath
        port map (
            clk       => clk,
            rst       => rst,

            en_range  => en_range,
            en_init   => en_init,
            en_cordic => en_cordic,
            en_result => en_result,

            z_in      => z_in,

            y_result  => y_out,
            done      => done_dp,

            -- debug
            r_test    => r_test,
            k_test    => k_test,
            x_test    => x_test,
            y_test    => y_test,
            z_test    => z_test,

            kr_test   => open,
            rr_test   => open,

            iter      => iter
        );

    rang      <= en_range;
    init      <= en_init;
    cordic    <= en_cordic;
    result    <= en_result;

    iter_test <= iter;

end architecture;
