import numpy as np

# calcTouRate
def calcTouRate():
    Month = np.array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    Day = np.array([31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31])
    onPrice = np.array([0.17, 0.17])
    midPrice = np.array([0.113, 0.113])
    offPrice = np.array([0.083, 0.083])
    onHours = np.array([[11, 12, 13, 14, 15, 16], [7, 8, 9, 10, 17, 18]])
    midHours = np.array([[7, 8, 9, 10, 17, 18], [11, 12, 13, 14, 15, 16]])
    offHours = np.array([[1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24], [1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24]])
    # define summer season
    Month[4:7] = 1
    # Holidays definition based on the number of the day in 365 days format
    holidays = np.array([10, 50, 76, 167, 298, 340])

    Cbuy = np.zeros(8760)
    for m in range(12):
        if m == 0:
            t_start = 0
            t_end = 24 * Day[m]
        else:
            t_start = 24 * Day[m - 1]
            t_end = 24 * Day[m]

        if Month[m] == 0:  # for summer

            tp = onHours[0, :]
            tm = midHours[0, :]
            toff = offHours[0, :]
            P_peak = onPrice[0]
            P_mid = midPrice[0]
            P_offpeak = offPrice[0]

        else:  # for winter
            tp = onHours[1, :]
            tm = midHours[1, :]
            toff = offHours[1, :]
            P_peak = onPrice[1]
            P_mid = midPrice[1]
            P_offpeak = offPrice[1]

        for j in range(t_start, t_end):
            h = t_end - t_start + j
            if h in tp:
                Cbuy[j] = P_peak  # set onhours to P_peak
            elif h in tm:
                Cbuy[j] = P_mid  # set midHours to P_mid
            else:
                Cbuy[j] = P_offpeak  # set all hours to offpeak by default

    for d in range(365):
        if d % 7 >= 5:
            st = 24 * d + 1
            ed = 24 * (d + 1)
            Cbuy[st: ed] = P_offpeak

    holidays = holidays - 1
    for d in range(365):
        if d in holidays:
            st = 24 * d + 1
            ed = 24 * (d + 1)
            Cbuy[st: ed] = P_offpeak
    return Cbuy

Cbuy = calcTouRate()

