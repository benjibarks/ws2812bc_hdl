package ws2812bc_pkg;
    // Timing in seconds
    parameter T0H = 0.00000025;
    parameter T0L = 0.00000060;
    parameter T1H = 0.00000060;
    parameter T1L = 0.00000060;
    parameter RESET_TIME = 0.0002805;

    parameter T0H_MIN_SEC = 0.00000022;
    parameter T0H_MAX_SEC = 0.00000038;
    parameter T1H_MIN_SEC = 0.00000058;
    parameter T1H_MAX_SEC = 0.000001;
    parameter T0L_MIN_SEC = 0.00000058;
    parameter T0L_MAX_SEC = 0.000001;
    parameter T1L_MIN_SEC = 0.00000058;
    parameter T1L_MAX_SEC = 0.000001;
    parameter RESET_TIME_SEC = 0.000280;
endpackage