Docs - os
=====

First addresses of the memory are reserved, changing these addresses might result in undefined behaviour:  
1. 0x0 -> Reference for `0x0'
2. 0x1 -> Reference for `0x1'
3. 0x2 -> Reference for `0x2'
4. 0x3 -> Reference for `0x4'
5. 0x4 -> Reference for `0x8'
6. 0x5 -> Reference for `0x10'
7. 0x6 -> Reference for `0x20'
8. 0x7 -> Reference for `0x40'
9. 0x8 -> Reference for `0x80'
10. 0x9 -> Reference for `0x100'
11. 0xa -> Reference for `0x200'
12. 0xb -> Reference for `0x400'
13. 0xc -> Reference for `0x800'
14. 0xd -> Reference for `0x1000'
15. 0xe -> Reference for `0x2000'
16. 0xf -> Reference for `0x4000'
17. 0x10 -> Reference for `0x8000'
18. 0x11 -> Reference for `0x10000'
19. 0x12 -> Reference for `0x20000'
20. 0x13 -> Reference for `0x40000'
21. 0x14 -> Reference for `0x80000'
22. 0x15 -> Reference for `0x100000'
23. 0x16 -> Reference for `0x200000'
24. 0x17 -> Reference for `0x400000'
25. 0x18 -> Reference for `0x800000'
26. 0x19 -> Reference for `0x1000000'
27. 0x1a -> Reference for `0x2000000'
28. 0x1b -> Reference for `0x4000000'
29. 0x1c -> Reference for `0x8000000'
30. 0x1d -> Reference for `0x10000000'
31. 0x1e -> Reference for `0x20000000'
32. 0x1f -> Reference for `0x40000000'
33. 0x20 -> Reference for `0x80000000'
34. 0x21 -> Reference for `0x100000000'
35. 0x22 -> Reference for `0x200000000'
36. 0x23 -> Reference for `0x400000000'
37. 0x24 -> Reference for `0x800000000'
38. 0x25 -> Reference for `0x1000000000'
39. 0x26 -> Reference for `0x2000000000'
40. 0x27 -> Reference for `0x4000000000'
41. 0x28 -> Reference for `0x8000000000'
42. 0x29 -> Reference for `0x10000000000'
43. 0x2a -> Reference for `0x20000000000'
44. 0x2b -> Reference for `0x40000000000'
45. 0x2c -> Reference for `0x80000000000'
46. 0x2d -> Reference for `0x100000000000'
47. 0x2e -> Reference for `0x200000000000'
48. 0x2f -> Reference for `0x400000000000'
49. 0x30 -> Reference for `0x800000000000'
50. 0x31 -> Reference for `0x1000000000000'
51. 0x32 -> Reference for `0x2000000000000'
52. 0x33 -> Reference for `0x4000000000000'
53. 0x34 -> Reference for `0x8000000000000'
54. 0x35 -> Reference for `0x10000000000000'
55. 0x36 -> Reference for `0x20000000000000'
56. 0x37 -> Reference for `0x40000000000000'
57. 0x38 -> Reference for `0x80000000000000'
58. 0x39 -> Reference for `0x100000000000000'
59. 0x3a -> Reference for `0x200000000000000'
60. 0x3b -> Reference for `0x400000000000000'
61. 0x3c -> Reference for `0x800000000000000'
62. 0x3d -> Reference for `0x1000000000000000'
63. 0x3e -> Reference for `0x2000000000000000'
64. 0x3f -> Reference for `0x4000000000000000'
65. 0x40 -> Reference for `0x8000000000000000'

66. 0x41 -> Scratch pad 1
67. 0x42 -> Scratch pad 2
68. 0x43 -> Scratch pad 3
69. 0x44 -> Scratch pad 4

70. 0x45 - 0x53 -> Reserved for future use

71. 0x54 -> Stack Pointer
72. 0x55 -> Base Pointer

73. 0x56 - 0x80 -> Reserved for future use

74. 0x81 - 0x2DB -> VGA memory of size 40*60 characters with 8bit color mode with 4bits for foreground and 4 for background color
75. 0x2DC - 0x3FC8 -> Address space reserved for future video memory expansion (upto 4k display mode with character size of 16*8)

76. 0x3FC9 - 0x4000 -> Reserved for future use
