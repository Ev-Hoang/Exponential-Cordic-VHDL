library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity cordic_datapath is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;

        en_range  : in  std_logic;
        en_init   : in  std_logic;
        en_cordic : in  std_logic;
        en_result : in  std_logic;

        z_in      : in  q8_24;

        y_result  : out q8_24;
        done      : out std_logic;

        -- test
        r_test    : out q8_24;
        k_test    : out integer;
        x_test    : out q8_24;
        y_test    : out q8_24;
        z_test    : out q8_24;

	kr_test   : out integer;
	rr_test   : out q8_24;

        -- feedback to controller
        iter      : out integer range 0 to N_ITER
    );
end entity;

architecture rtl of cordic_datapath is
    signal x_reg, y_reg : q8_24;
    signal z_reg        : q8_24;
    signal k_reg        : integer;
    signal r_reg        : q8_24;
    signal y_out        : q8_24;
    signal iter_reg     : integer range 0 to N_ITER;

    signal r_range       : q8_24;
    signal k_range       : integer;
    signal x_next, y_next, z_next : q8_24;
    signal x_init, y_init, z_init : q8_24;
    signal range_done    : std_logic;
    signal init_done     : std_logic;
    signal cordic_done   : std_logic;
    signal result_done   : std_logic;

begin

    ------------------------------------------------------------------
    -- RANGE REDUCTION BLOCK (state: RANG)
    ------------------------------------------------------------------
    u_range : entity work.range_unit
        port map (
            clk   => clk,
            en    => en_range,
            t_in  => z_in,
            k_out => k_range,
            r_out => r_range,
            done  => range_done
        );

    ------------------------------------------------------------------
    -- INIT BLOCK (state: INIT)
    ------------------------------------------------------------------
    u_init : entity work.init_unit
        port map (
            clk   => clk,
            en    => en_init,
            r_in  => r_reg,
            x_out => x_init,
            y_out => y_init,
            z_out => z_init,
            done  => init_done
        );

    ------------------------------------------------------------------
    -- CORDIC CORE (state: CORDIC)
    ------------------------------------------------------------------
    u_cordic : entity work.cordic_unit
        port map (
            clk   => clk,
            en    => en_cordic,
            dir   => z_reg(31),
            x_in  => x_reg,
            y_in  => y_reg,
            z_in  => z_reg,
            iter  => iter_reg,
            x_out => x_next,
            y_out => y_next,
            z_out => z_next,
	    done  => cordic_done
        );

    ------------------------------------------------------------------
    -- RESULT BLOCK (state: RESULT)
    ------------------------------------------------------------------
    u_result : entity work.result_unit
        port map (
            clk   => clk,
            en    => en_result,
            x_in  => x_reg,
            y_in  => y_reg,
            k_in  => k_reg,
            y_out => y_out,
	    done  => result_done
        );

    ------------------------------------------------------------------
    -- DATAPATH REGISTERS UPDATE
    ------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            x_reg    <= (others => '0');
            y_reg    <= (others => '0');
            z_reg    <= (others => '0');
	    y_result <= (others => '0');
            k_reg    <= 0;
            iter_reg <= 0;
            done     <= '0';
        elsif rising_edge(clk) then

	    done     <= '0';

            -- RANGE 
            if range_done = '1' then
                k_reg <= k_range;
		r_reg <= r_range;
		done  <= '1';

            -- INIT
            elsif init_done = '1' then
                x_reg    <= x_init;
                y_reg    <= y_init;
                z_reg    <= z_init;
                iter_reg <= 0;
		done     <= '1';

            -- CORDIC 
            elsif cordic_done = '1' then
                x_reg    <= x_next;
                y_reg    <= y_next;
                z_reg    <= z_next;
                iter_reg <= iter_reg + 1;
		done <= '1';

	    -- RESULT
	    elsif result_done = '1' then
		y_result <= y_out;
		done     <= '1';
            end if;		
        end if;
    end process;

    ------------------------------------------------------------------
    -- FEEDBACK TO CONTROLLER
    ------------------------------------------------------------------
    iter     <= iter_reg;

    rr_test <= r_range;
    kr_test <= k_range;

    k_test <= k_reg;
    r_test <= r_reg;
    x_test <= x_reg;
    y_test <= y_reg;
    z_test <= z_reg;
end architecture;
