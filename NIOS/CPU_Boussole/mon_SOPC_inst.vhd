  --Example instantiation for system 'mon_SOPC'
  mon_SOPC_inst : mon_SOPC
    port map(
      Leds_from_the_boussole_0 => Leds_from_the_boussole_0,
      out_port_from_the_OutputPIO => out_port_from_the_OutputPIO,
      out_pwm_from_the_avalon_pwm_0 => out_pwm_from_the_avalon_pwm_0,
      IN_PWM_COMPAS_to_the_boussole_0 => IN_PWM_COMPAS_to_the_boussole_0,
      clk_0 => clk_0,
      in_port_to_the_InputPIO => in_port_to_the_InputPIO,
      reset_n => reset_n
    );


