package ws2812bc_pkg;
    // Timing in seconds
    parameter T0H = 0.000000001;
    parameter T0L = 0.000000004;
    parameter T1H = 0.000000004;
    parameter T1L = 0.000000001;
    parameter RESET_TIME = 0.00000001;

    // Model timing allwowed error margin
    parameter ALLOWED_ERROR = 0.000000001;

    parameter T0H_MIN_SEC = T0H - ALLOWED_ERROR;
    parameter T0H_MAX_SEC = T0H + ALLOWED_ERROR;
    parameter T1H_MIN_SEC = T1H - ALLOWED_ERROR;
    parameter T1H_MAX_SEC = T1H + ALLOWED_ERROR;
    parameter T0L_MIN_SEC = T0L - ALLOWED_ERROR;
    parameter T0L_MAX_SEC = T0L + ALLOWED_ERROR;
    parameter T1L_MIN_SEC = T1L - ALLOWED_ERROR;
    parameter T1L_MAX_SEC = T1L + ALLOWED_ERROR;
    parameter RESET_TIME_SEC = RESET_TIME - ALLOWED_ERROR;
endpackage