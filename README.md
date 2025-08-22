Here's a draft for your new README file based on the Verilog code for the traffic light controller.

***

# Verilog Traffic Light Controller 🚦

## 📝 Overview

This project is a **Verilog implementation of a traffic light controller** for a standard four-way intersection. The design uses a Finite State Machine (FSM) to manage the sequence of traffic lights, ensuring that traffic flows safely and efficiently through the intersection. The controller logic is synthesized and tested using a testbench to verify its functionality.

---

## ✨ Features

* **FSM-Based Design**: Utilizes a Moore Finite State Machine with eight states to control the traffic light sequence.
* **Safe Transitions**: Includes yellow light states between green and red to ensure vehicles have adequate time to clear the intersection.
* **Standard Four-Way Control**: Manages two main traffic directions (e.g., North-South and East-West).
* **Simulation Ready**: Comes with a comprehensive testbench (`tb_traffic.v`) to simulate and validate the controller's behavior over time.

---

## ⚙️ How It Works

The core of the controller is a Finite State Machine (FSM) defined in `traffic_light.v`.

1.  **State Definition**: The FSM is built around eight states, each corresponding to a specific combination of lights for the two directions (Main Street and Side Street). The states are defined using parameters (`S0` through `S7`).
2.  **State Transitions**: The machine transitions from one state to the next on every positive edge of the clock signal (`clk`). A `reset` signal is used to initialize the FSM to the starting state (`S0`), where the main street has a green light.
3.  **Output Logic**: The `always @(state)` block defines the output logic. Based on the current state, it assigns the correct color (Red, Yellow, or Green) to the lights for the main and side streets. For instance, in state `S0`, `main_light` is green and `side_light` is red.
4.  **Timing**: The duration of each light phase (e.g., how long a light stays green) is determined by the number of clock cycles the FSM remains in a particular state. The testbench `tb_traffic.v` controls the simulation time.

### State Diagram Flow

The sequence is designed to prevent conflicts:
* **Main Green** ➡️ **Main Yellow** ➡️ **All Red**
* **Side Green** ➡️ **Side Yellow** ➡️ **All Red**
* The cycle repeats, ensuring one direction is red before the other turns green.

---

## 📂 File Descriptions

* `traffic_light.v`: The main Verilog module containing the FSM logic for the traffic light controller. It takes `clk` and `reset` as inputs and outputs the state of the `main_light` and `side_light`.
* `tb_traffic.v`: The Verilog testbench used to simulate the `traffic_light` module. It generates the clock and reset signals, instantiates the controller, and runs the simulation for a defined period to verify the sequence of light changes.

---

## ▶️ How to Run

1.  **EDA Tool**: You will need an Electronic Design Automation (EDA) tool that supports Verilog simulation, such as ModelSim, Vivado, or an online simulator like EDA Playground.
2.  **Compile Files**: Compile both `traffic_light.v` and `tb_traffic.v` in the simulator.
3.  **Run Simulation**: Start the simulation from the testbench (`tb_traffic`).
4.  **Observe Waveform**: Open the waveform viewer to observe the changes in `main_light`, `side_light`, and `state` signals over time. This will show the controller cycling through its states as expected.

---

## 📊 Simulation Results

The simulation output shows the state transitions and the corresponding light changes over time. The waveform confirms that the FSM correctly cycles through the predefined states, managing the traffic flow without conflicts.



The waveform clearly displays:
* The `clk` signal driving the state changes.
* The `reset` signal initializing the FSM to state `S0`.
* The `state` register progressing from `S0` to `S7` and cycling back.
* The `main_light` and `side_light` outputs changing according to the current state, with appropriate yellow light delays.
