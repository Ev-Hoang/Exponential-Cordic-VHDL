library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;  
use work.cordic_lut_pkg.all;  

entity tb_atanh_lut is
end entity;

architecture sim of tb_atanh_lut is
begin
    process
        variable real_val : real;
    begin
        report "=== Testing ATANH LUT ===";
        for i in ATANH_LUT'range loop
            real_val := to_real_q2_24(ATANH_LUT(i));
            report "ATANH_LUT(" & integer'image(i) & ") = " & real'image(real_val);
        end loop;
        wait;
    end process;
end architecture;

