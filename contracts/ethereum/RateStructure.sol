//SPDX-License-Identifier: Unlicense
// contracts/HouseFactory.sol
/// @title
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "./House.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RateStructure { 

    uint[] private onPrice;
    uint[] private midPrice;
    uint[] private offPrice;
    uint[][] private onHours;
    uint[][] private midHours;
    uint[][] private offHours;
    uint[] private months;
    uint[] private holidays;
    uint[] private daysInMonth;

    constructor() {

        onPrice = [17, 17]; // divide by 100
        midPrice = [113, 113]; // divide by 1000
        offPrice = [83, 83]; // divide by 1000
        onHours = [[11, 12, 13, 14, 15, 16], [7, 8, 9, 10, 17, 18]];
        midHours = [[7, 8, 9, 10, 17, 18], [11, 12, 13, 14, 15, 16]];
        offHours = [[1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24], [1, 2, 3, 4, 5, 6, 19, 20, 21, 22, 23, 24]];
        months = [0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0];
        holidays = [10, 50, 76, 167, 298, 340];
        daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];


    }

    // function calcSeasonalRate(uint[] prices, uint[] months, uint[] daysInMonth) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 1;

    //     for (int m = 0; m < 12;){
    //         uint hoursStart = hCount;
    //         uint hoursEnd = hoursStart + (24 * daysInMonth[m]);
    //         uint hoursRange = 0;
    //         Cbuy[hoursRange] = prices[];
    //         hCount = hoursEnd;
    //         unchecked { m++; }
    //     }
    //     return Cbuy;
    // }

    // function calcFlatRate(uint price) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 0;
    //     for (int h = 0; h < 8760;){
    //         Cbuy[h] = price;
    //         unchecked { h++; }
    //     }
    //     return Cbuy;

    // }

    // function calcMonthlyRate(uint[] prices, uint[] daysInMonth) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 0;
    //     for (int m = 0; m < 12;){
    //         uint range = 24 * daysInMonth[m];
    //         for (int h = 0; h < range;){
    //             Cbuy[hCount] = prices[m];
    //             hCount += 1;
    //             unchecked { h++; }
    //         }
    //         unchecked { m++; }
    //     }
    //     return Cbuy;
    // }

    // function calcTieredRate(uint[] prices, uint[] tierMax, uint[] load, uint[] daysInMonth) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 0;
    //     for (int m = 0; m < 12;){
    //         uint monthlyLoad = 0;
    //         uint range = 24 * daysInMonth[m];
    //         for (int h = 0; h < range;){
    //             monthlyLoad += load[hCount];
    //             if (monthlyLoad < tierMax[0]){
    //                 Cbuy[hCount] = prices[0];
    //             }
    //             else if (monthlyLoad < tierMax[1]){
    //                 Cbuy[hCount] = prices[1];
    //             }
    //             else {
    //                 Cbuy[hCount] = prices[2];
    //             }

    //             hCount += 1;
    //             unchecked { h++; }
    //         }
    //         unchecked { m++; }
    //     }
    //     return Cbuy;
    // }

    // function calcSeasonalTieredRate(uint[][] prices, uint[][] tierMax, uint[] load, uint[] months, uint[] daysInMonth) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 0;
    //     for (int m = 0; m < 12;){
    //         uint monthlyLoad = 0;
    //         uint months_m = months[m];
    //         uint range = 24 * daysInMonth[m];
    //         for (int h = 0; h < range;){
    //             monthlyLoad += load[hCount];
    //             if (monthlyLoad < tierMax[months_m][0]){
    //                 Cbuy[hCount] = prices[months_m][0];
    //             }
    //             else if (monthlyLoad < tierMax[months_m][1]){
    //                 Cbuy[hCount] = prices[months_m][1];
    //             }
    //             else {
    //                 Cbuy[hCount] = prices[months_m][2];
    //             }
                
    //             hCount += 1;
    //             unchecked { h++; }
    //         }
    //         unchecked { m++; }
    //     }
    //     return Cbuy;
    // }

    // function calcMonthlyTieredRate(uint[][] prices, uint[][] tierMax, uint[] load, uint[] daysInMonth) public returns (uint[])
    // {
    //     uint[] Cbuy = new uint[8760];
    //     uint hCount = 0;
    //     for (int m = 0; m < 12;){
    //         uint monthlyLoad = 0;
    //         uint range = 24 * daysInMonth[m];
    //         for (int h = 0; h < range;){
    //             monthlyLoad += load[hCount];
    //             if (monthlyLoad < tierMax[m][0]){
    //                 Cbuy[hCount] = prices[m][0];
    //             }
    //             else if (monthlyLoad < tierMax[m][1]){
    //                 Cbuy[hCount] = prices[m][1];
    //             }
    //             else {
    //                 Cbuy[hCount] = prices[m][2];
    //             }
                
    //             hCount += 1;
    //             unchecked { h++; }
    //         }
    //         unchecked { m++; }
    //     }
    //     return Cbuy;
    // }

    function calcTouRate() public returns (uint[] memory)
    {
        uint[] memory Cbuy = new uint[](8760);
        uint p_peak;
        uint p_mid;
        uint p_offpeak;

        for (uint m = 0; m < 12;){
            uint t_end;
            uint t_start;

            if (m == 0){
                t_start = 0;
                t_end = 24 * daysInMonth[m];
            }
            else {
                t_start = 24 * daysInMonth[m - 1];
                t_end = 24 * daysInMonth[m];
            }

            uint[] memory tp;
            uint[] memory tm;

            if (months[m] == 0){ // for summer
                tp = onHours[0];
                tm = midHours[0];
                p_peak = onPrice[0];
                p_mid = midPrice[0];
                p_offpeak = offPrice[0];
            }
            else {
                tp = onHours[1];
                tm = midHours[1];
                p_peak = onPrice[1];
                p_mid = midPrice[1];
                p_offpeak = offPrice[1];
            }

            for (uint j = t_start; j < t_end; ){
                uint h = t_end - t_start + j;
                bool h_in_tp = false;
                for (uint k = 0; k < tp.length;){
                    if (tp[k] == h){
                        h_in_tp = true;
                    }
                    unchecked { k++; }
                }
                if (h_in_tp){
                    Cbuy[j] = p_peak;
                    unchecked { j++; }
                    continue;
                }
                bool h_in_tm = false;
                for (uint k = 0; k < tp.length;){
                    if (tm[k] == h){
                        h_in_tm = true;
                    }
                    unchecked { k++; }
                }
                if (h_in_tm){
                    Cbuy[j] = p_peak;
                    unchecked { j++; }
                    continue;
                }
                else{
                    Cbuy[j] = p_offpeak;
                }

                unchecked { j++; }
            }
            unchecked { m++; }
        }

        uint st;
        uint ed;
        uint holidayPointer = 0;
        for (uint d = 0; d < 365;){
            if (d % 7 >= 5 || d == holidays[holidayPointer]){
                unchecked { st = 24 * d + 1;}
                unchecked { ed = 24 * (d + 1);}
                for (uint k = st; k < ed;){
                    Cbuy[k] = p_offpeak;
                    unchecked { k++; }
                }
            }
            unchecked { d++; }
        }
        return Cbuy;
    }

}