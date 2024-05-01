Implement the rank-order (RO) sorter presented in [[1]](https://ieeexplore.ieee.org/document/9195248).

**Environment**:

- `python3.7.16`
- `modelSim SE-64 10.4 (2014)`

**Usage**:

- generate main part of systemverilog/verilog code

  ```shell
  $ cd scripts
  $ python3 autogen.py
  ```

- add ports for the generated codes and move to `src` folder

- simulate using modelsim

  ```shell
  vsim -do sim.do
  ```

## Reference

[1] B. Le Gal, Y. Delomier, C. Leroux, and C. Jégo, “Low-Latency Sorter Architecture for Polar Codes Successive-Cancellation-List Decoding,” in *2020 IEEE Workshop on Signal Processing Systems (SiPS)*, Oct. 2020, pp. 1–5. doi: [10.1109/SiPS50750.2020.9195248](https://doi.org/10.1109/SiPS50750.2020.9195248).