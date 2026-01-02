library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity cordic_controller is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;

        iter      : in  integer range 0 to N_ITER;
        done_dp   : in  std_logic;

        en_range  : out std_logic;
        en_init   : out std_logic;
        en_cordic : out std_logic;
        en_result : out std_logic;

        done      : out std_logic
    );
end entity;

architecture rtl of cordic_controller is
    type state_t is (
        IDLE,
        RANG,
        INIT,
        CORDIC,
        RESULT,
        FINISH
    );

    signal state, next_state : state_t;

    -- state entry pulse
    signal state_enter : std_logic;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, start, done_dp, iter)
    begin
        next_state <= state;

        case state is

            when IDLE =>
                if start = '1' then
                    next_state <= RANG;
                end if;

            when RANG =>
                if done_dp = '1' then
                    next_state <= INIT;
                end if;

            when INIT =>
                if done_dp = '1' then
                    next_state <= CORDIC;
                end if;

            when CORDIC =>
                if done_dp = '1' then
                    if iter = N_ITER then
                        next_state <= RESULT;
                    else
                        next_state <= CORDIC;
                    end if;
                end if;

            when RESULT =>
                if done_dp = '1' then
                    next_state <= FINISH;
                end if;

            when FINISH =>
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;

        end case;
    end process;

    process(clk, rst)
        variable prev_state : state_t;
    begin
        if rst = '1' then
            prev_state  := IDLE;
            state_enter <= '0';
        elsif rising_edge(clk) then
            if state /= prev_state then
                state_enter <= '1';
            else
                state_enter <= '0';
            end if;
            prev_state := state;
        end if;
    end process;


process(state, state_enter, done_dp, iter)
begin
    en_range  <= '0';
    en_init   <= '0';
    en_cordic <= '0';
    en_result <= '0';
    done      <= '0';

    case state is

        when RANG =>
            if state_enter = '1' then
                en_range <= '1';
            end if;

        when INIT =>
            if state_enter = '1' then
                en_init <= '1';
            end if;

        when CORDIC =>
            if state_enter = '1' then
                en_cordic <= '1';
            elsif done_dp = '1' and iter < N_ITER then
                en_cordic <= '1';
            end if;

        when RESULT =>
            if state_enter = '1' then
                en_result <= '1';
            end if;

        when FINISH =>
            done <= '1';

        when others =>
            null;

    end case;
end process;


end architecture;

