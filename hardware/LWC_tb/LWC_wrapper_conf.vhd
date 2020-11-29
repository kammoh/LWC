-- In Vivado simulation top needs to be set to Wrapped_LWC_Conf!
configuration Wrapped_LWC_Conf of LWC_TB is
    for TB
        for all : LWC
            use entity work.LWC_wrapper; -- either RTL or Verilog netlist
        end for;
    end for;
end configuration;