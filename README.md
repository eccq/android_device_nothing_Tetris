# Device configuration for CMF Phone 1

The CMF Phone 1 ("Tetris") is a budget/mid-range smartphone from CMF by Nothing.

It was released in July 2024.

## Device specifications

Basic    | Spec Sheet
--------:|:-------------------------
CPU      | Octa-core (4x2.5 GHz Cortex-A78 & 4x2.0 GHz Cortex-A55)
Platform | MediaTek Dimensity 7300 (4 nm)
GPU      | Mali-G615 MC2
Memory   | 6/8 GB, LPDDR4X
Storage  | 128/256 GB, UFS 2.2
Shipped Android Version | 14
Battery  | Li-ion 5000 mAh, non-removable
Display  | 1080 x 2400 pixels, 6.67 inches (~395 ppi density)
Camera   | 50 MP main, 16 MP front 

## Device picture

![CMF Phone 1](https://fdn2.gsmarena.com/vv/pics/nothing/nothing-cmf-phone-1-02.jpg "CMF Phone 1")

## DescartesOS

This tree builds DescartesOS (based on LineageOS 24 / Android 17) for the CMF Phone 1.

Build:

```
source build/envsetup.sh
lunch lineage_Tetris cp2a userdebug
m bacon
```

## Credits

| Who | What |
|---|---|
| [LineageOS](https://github.com/LineageOS) | Android base, `hardware/mediatek`, `device/mediatek/sepolicy_vndr`, `hardware/lineage/compat` |
| [crDroid Android](https://github.com/crdroidandroid) | Base of the DescartesOS vendor configuration |
| [CMF-Phone-1](https://github.com/CMF-Phone-1) | Original device, vendor and kernel trees for Tetris (`xylobium` / `a17`) |
| [lufrz](https://github.com/lufrz) | LineageOS 24 device tree, vendor and prebuilt kernel; Tetris Parts; power, GPU and audio tuning; UDFPS; EROFS; stock LK |
| [Sreelekshman](https://github.com/sreelekshman) | Original Tetris bring-up and maintenance |
| [Mashopy](https://github.com/Mashopy) | Device bring-up, fingerprint HAL, `libfs_avb` and fastbootd lock-state patches |
| [bengris32](https://github.com/bengris32) | Media, WLAN, audio and scheduler tuning |
| [Abhay Singh Gill](https://github.com/HELLBOY017), [sidharthify](https://github.com/sidharthify) | Fingerprint and UDFPS |
| [swiitch-OFF-Lab](https://github.com/swiitch-OFF-Lab) | `hardware/dolby` and `DolbyUI` |
| [Nothing archive](https://github.com/spike0en/nothing_archive) | Stock firmware archive (`Tetris_B4.1-260928-1140`) |
| [chakra](https://github.com/eccq) | DescartesOS port and maintenance |

### Contributors

Everyone who authored commits in this tree's history:

Aaron Kling, Abhay Singh Gill, Adam Shih, AdarshGrewal, Alexander Koskovich, alextrack2013, Arian, Arthur Hung, Avichal Rakesh, Bart Van Assche, basamaryan, bengris32, Beverly, Bowgo Tsai, Bruno Martins, chandu078, ChrisCatto, Chungkai Mei, cjh1249131356, claxten10, codeworkx, Cosmin Tanislav, Cyber Knight, Danny Lin, electimon, Erfan Abdi, Evgenii Stepanov, Giovanni Ricca, guibing, hiroshi, Jaegeuk Kim, Jake Weinstein, J. Avila, Jeff Chang, Jenhao Chen, Jesse Chan, jiabin, Jis G Jacob, Jooyung Han, JoshuaDoes, Kshitij, Kujou Yuko, Kyle Tso, Lennart Wieboldt, Lokesh Gidra, lufrz, LuK1337, Martin Liu, Mashopy, me-cafebabe, Michael Bestas, Michael Wright, mikoker, Minchan Kim, Nicholas Lim, nift4, Nolen Johnson, Omkar Chandorkar, Pedro Garau Martínez, pjgowtham, Pullakavi Srinivas, Qais Yousef, Rachel Lee, Randall Huang, Ray Chi, rio004, Saalim Quadri, SahilSonar, Sebastiano Barezzi, Seth Moore, sidharthify, sm455, snapboss, sreelekshman, Sriharsha Allenki, Sungtak Lee, swiitchOFF, TheMysticle, Thierry Strudel, Tim Zimmermann, Vaisakh Murali, Victor Hsieh, Vincent Wang, Wei Wang, Woody Lin, Woomymy, Yan Yan, Yong Zhang, Yumi Yukimura.

Thank you all.
