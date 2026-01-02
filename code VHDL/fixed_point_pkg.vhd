library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fixed_point_pkg is
    subtype q8_24   is signed(31 downto 0);
    subtype q2_24   is signed(25 downto 0);
    subtype q16_48  is signed(63 downto 0);

    constant N_ITER : integer := 30;

    constant K_INV_Q : q8_24 :=
        to_signed(integer(1.207529 * 2.0**24), 32);

    constant LN2_Q : q8_24 :=
        to_signed(integer(0.69314718056 * 2.0**24), 32);

    constant INV_LN2_Q : q8_24 :=
        to_signed(integer(1.44269504089 * 2.0**24), 32);

    constant EPS_Q16_48 : q16_48 := 
	"0000000000000000" & "000000010000000000000000000000000000000000000000";


    function to_q8_24(a : signed) return q8_24;
    function to_real_q8_24(a : q8_24) return real;
    function to_real_q2_24(a : q2_24) return real;

end package fixed_point_pkg;


package body fixed_point_pkg is

    function to_q8_24(a : signed) return q8_24 is
    begin
        return resize(a, 32);
    end function;

    function to_real_q8_24(a : q8_24) return real is
    begin
        return real(to_integer(a)) / 2.0**24;
    end function;

    function to_real_q2_24(a : q2_24) return real is
    begin
        return real(to_integer(a)) / 2.0**24;
    end function;

end package body fixed_point_pkg;

