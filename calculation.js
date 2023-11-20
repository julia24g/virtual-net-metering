function calcTouRate() {
    const Month = new Array(12).fill(0);
    const Day = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    const onPrice = [170, 170]; // multiplied by 10^3
    const midPrice = [113, 113]; // multiplied by 10^3
    const offPrice = [83, 83]; // multiplied by 10^3
    const onHours = [
        [11, 12, 13, 14, 15, 16],
        [7, 8, 9, 10, 17, 18]
    ];
    const midHours = [
        [7, 8, 9, 10, 17, 18],
        [11, 12, 13, 14, 15, 16]
    ];
    const offHours = [
        [1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24],
        [1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24]
    ];

    // define summer season
    Month.fill(1, 4, 7);

    // Holidays definition based on the number of the day in 365 days format
    const holidays = [10, 50, 76, 167, 298, 340];

    const Cbuy = new Array(8760).fill(0);

    let tp, tm, toff, P_peak, P_mid, P_offpeak;

    for (let m = 0; m < 12; m++) {
        let t_start, t_end;
        if (m === 0) {
            t_start = 0;
            t_end = 24 * Day[m];
        } else {
            t_start = 24 * Day[m - 1];
            t_end = 24 * Day[m];
        }

        if (Month[m] === 0) {
            // for summer
            tp = onHours[0];
            tm = midHours[0];
            toff = offHours[0];
            P_peak = onPrice[0];
            P_mid = midPrice[0];
            P_offpeak = offPrice[0];
        } else {
            // for winter
            tp = onHours[1];
            tm = midHours[1];
            toff = offHours[1];
            P_peak = onPrice[1];
            P_mid = midPrice[1];
            P_offpeak = offPrice[1];
        }

        for (let j = t_start; j < t_end; j++) {
            const h = t_end - t_start + j;
            if (tp.includes(h)) {
                Cbuy[j] = P_peak; // set onhours to P_peak
            } else if (tm.includes(h)) {
                Cbuy[j] = P_mid; // set midHours to P_mid
            } else {
                Cbuy[j] = P_offpeak; // set all hours to offpeak by default
            }
        }
    }

    for (let d = 0; d < 365; d++) {
        if (d % 7 >= 5) {
            const st = 24 * d + 1;
            const ed = 24 * (d + 1);
            Cbuy.fill(P_offpeak, st, ed);
        }
    }

    for (const d of holidays) {
        const st = 24 * d + 1;
        const ed = 24 * (d + 1);
        Cbuy.fill(P_offpeak, st, ed);
    }

    return Cbuy;
}

module.exports = { calcTouRate };
