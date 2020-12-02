-- In Vivado simulation top needs to be set to Wrapped_LWC_Conf!
configuration LWC_TB_2pass_wrapper_conf of LWC_TB is
    for TB
        for uut : LWC
            use entity work.LWC_TB_2pass_wrapper_uut; -- either RTL or Verilog netlist
        end for;
    end for;
end configuration;