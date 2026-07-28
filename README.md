# End-to-End FMCW Radar Simulation and Target Detection

End-to-end FMCW radar simulation in MATLAB with physics-based IQ generation, range–Doppler processing, CA-CFAR detection, feature extraction, LFM matched filtering, and a Verilog target classifier.

## Project Overview

This project implements an end-to-end simulated radar processing chain, beginning with physics-based FMCW IQ data generation and ending with target detection, parameter estimation, feature extraction, and hardware-oriented classification.

Target returns are scaled using the monostatic radar range equation, allowing received power and input SNR to vary realistically with target range and radar cross section. The generated IQ data are processed using moving-target clutter suppression, Hann windowing, two-dimensional FFT processing, and CA-CFAR detection.

A separate LFM pulse-compression experiment demonstrates matched filtering and processing gain. A Verilog classifier is also included to demonstrate how encoded radar features could be evaluated using low-latency digital logic.

## Processing Chain

1. Define radar and target parameters
2. Calculate received power using the monostatic radar range equation
3. Generate complex FMCW IQ data with thermal receiver noise
4. Apply slow-time mean subtraction for stationary-clutter suppression
5. Apply two-dimensional Hann windowing
6. Generate the range–Doppler map using 2-D FFT processing
7. Perform two-dimensional CA-CFAR detection
8. Cluster detected cells and select target detections
9. Estimate target range and signed radial velocity
10. Extract radar features for classification and analysis

## Radar Configuration

| Parameter | Value |
|---|---:|
| Carrier frequency | 10 GHz |
| Sweep bandwidth | 20 MHz |
| Fast-time samples | 512 per chirp |
| Chirps per frame | 256 |
| Range resolution | 7.5 m |
| Maximum simulated range | Approximately 1,920 m |
| Unambiguous velocity | Approximately ±150 m/s |

## Physics-Based Dataset

The final dataset contains ten simulated dog, human, car, and plane scenarios.

- Target ranges: 50–420 m
- Radial velocities: −120 to +85 m/s
- Input SNR values: −3.59 to +4.57 dB
- Complex thermal receiver noise: −95.96 dBm
- Detection performed without truth-centered range or velocity gating

The dataset is generated directly by the included MATLAB code and does not require an external radar dataset.

## Results

The final processing pipeline detected all ten physics-based targets, including targets whose received signals were below the receiver noise level before coherent processing.

| Performance Metric | Result |
|---|---:|
| Detection rate | 100% (10/10 scenarios) |
| Mean absolute range error | 1.75 m |
| Mean absolute velocity error | 0.385 m/s |
| Lowest detected input SNR | −3.59 dB |
| Processed detection SNR | 43.40–51.02 dB |

The remaining estimation errors are primarily limited by the finite range and Doppler resolution of the two-dimensional FFT.

## LFM Matched Filtering

A standalone linear frequency-modulated pulse-compression experiment was implemented to demonstrate matched-filter processing.

The matched filter is defined as the time-reversed complex conjugate of the transmitted waveform:

$$
h(t)=s^{*}(T_p-t)
$$

For a 20 MHz waveform bandwidth and a 10 μs pulse duration, the time-bandwidth product is:

$$
BT_p=200
$$

This corresponds to a theoretical processing gain of approximately:

$$
G_p = 10\log_{10}(BT_p) = 10\log_{10}(200) = 23.01\ \text{dB}
$$

| Matched-Filter Metric | Result |
|---|---:|
| Input SNR | −11.96 dB |
| Output SNR | 10.84 dB |
| Measured SNR improvement | 22.80 dB |
| Theoretical processing gain | 23.01 dB |
| Simulated target range | 300 m |
| Estimated target range | 300 m |

The LFM matched-filter experiment is a separate waveform demonstration and is not inserted into the FMCW range–Doppler processing chain.

## Radar Feature Extraction

The following measurements are extracted from each selected CA-CFAR target cluster:

- Estimated range
- Absolute radial speed
- Peak return power
- Processed detection SNR
- Number of detected CFAR cells
- Range spread
- Doppler spread

These features describe the target’s position, motion, return strength, and distribution within the range–Doppler map.

## Verilog Target Classifier

A hardware-oriented, rule-based target classifier was implemented in Verilog. It accepts encoded radar-feature inputs and generates classification outputs for:

- Dog
- Human
- Car
- Plane
- Alien or unknown target

The classifier was compiled and verified through RTL simulation using Icarus Verilog and a dedicated testbench.

The Verilog testbench uses representative encoded feature vectors. It demonstrates the proposed hardware-classification interface but does not directly import the MATLAB feature data.

## Repository Files

```text
end-to-end-fmcw-radar-simulation/
├── README.md
├── a_lfm_matched_filter_demo.m
├── b_generate_physics_based_fmcw_data.m
├── c_process_fmcw_detection_features.m
├── radar_classifier.v
├── radar_classifier_tb.v
```
## Running the MATLAB Code

### Requirements

- MATLAB
- Signal Processing Toolbox

### Execution Order

```matlab
run("a_lfm_matched_filter_demo.m")
run("b_generate_physics_based_fmcw_data.m")
run("c_process_fmcw_detection_features.m")
```

File `a_lfm_matched_filter_demo.m` is a standalone demonstration. File `b_generate_physics_based_fmcw_data.m` generates the scenario data required by `c_process_fmcw_detection_features.m`.

## Running the Verilog Simulation

Using Icarus Verilog:

```bash
iverilog -o radar_sim radar_classifier.v tb_radar_classifier.v
vvp radar_sim
```

### RTL Simulation Results

Representative encoded radar-feature inputs produced the expected one-hot classification outputs for all five test cases.

```text
scenario,target_valid,range,speed,amp,spread,motion,dog,human,car,plane,alien
dog_case,1,22,6,120,9,8,1,0,0,0,0
human_case,1,18,2,90,5,4,0,1,0,0,0
car_case,1,80,28,210,2,1,0,0,1,0,0
plane_case,1,200,95,240,1,1,0,0,0,1,0
alien_case,1,44,13,160,12,15,0,0,0,0,1
```

Each valid target activated exactly one classification output, verifying the rule-based classifier and dedicated testbench through RTL simulation.

