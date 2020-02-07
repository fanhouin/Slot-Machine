﻿# Slot-Machine
 
 
## 設計概念
一個令人上癮的遊戲，裏面包含的元素有：令人上癮、有趣、技術和運氣的成分 、能夠賺錢。

## 遊法
Step 1: 投幣。
Step 2: 遊戲開始 前 先判斷是否夠錢。 ( 15 $ )
Step 3: 檢查那一個 Mode Mode 0 是 正常模式， Mode 1 是 運氣模式。
Step 4: 按下按鈕 去停下 1~3列的圖案。
Step 5: 檢查每一列的圖案是否相同 。 若是相同 就掉錢，一段時間後回到Start。否則直接回到 Start。

## 困難與解決方法
1. 投幣器結構
a. 困難： 每次硬幣進了洞後的墜落點會不同， 而紅外線感應器 的位置 卻是固
定，有時候 沒有經過紅外線感應器就墜落到中獎器。
b. 解決：弄一個 \ / 型的結構，可以把硬幣 引到中間 的 出口 ，那麼硬幣一定
會經過紅外線感應器。
2. 中獎器 結構
a. 困難： 一塊長 20cm的擋板， 卻 只用馬達小小的轉軸 支撐著，還要擋著硬
幣，是很傷馬達 的 結構 ，而且馬達會因為過度受力而 無 法轉動 。
b. 解決： 因為棉線有良好的延展性，所以使用它 勾 著擋板的 尾 端作支撐。
3. Memory
a. 困難： 因為 不想 memory不足， 圖片 強制壓縮後就 會 變了模糊 又醜 。
b. 解決： 使用像素風的圖片。

## 分工
黃暉強：
遊戲編程和設計、音樂、LED、 switch、按鈕、投幣器


樊浩賢：
馬達、紅外線感應器、 7 segments display、外接按鈕、投幣器
