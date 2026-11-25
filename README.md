# Robot-hand grasping with multi-agent DDPG in Simulink

MATLAB / Simulink code that trains five DDPG agents, one per servo of a five-servo robot hand built in our lab as a prosthetic-hand prototype, on a Simulink model of the hand.
The model replays logged goal and present positions, estimates servo load with regression functions and velocity by differentiation, and rewards each agent for tracking the goal position without exceeding a load limit.
Author: Do-Gyeong Yuk.

<p align="center">
  <img src="docs/model_overview.png" alt="Overview of the Simulink model" width="460" />
  <br>
  <sub>Overview of the Simulink model with the five RL Agent blocks.</sub>
</p>

## Publications

- D.-G. Yuk, J. W. Sohn, "Haptic-based Robot Hand Grasping Technique Using Reinforcement Learning," Proc. SPIE Smart Structures + NDE 2024. https://doi.org/10.1117/12.3010674

## Repository structure

| Path | Purpose |
| --- | --- |
| `rl_model.m` | Builds the observation and action specifications, the actor and critic networks and five DDPG agents, and starts multi-agent training. |
| `reinforcemen_model2.slx` | Simulink model referenced by `rl_model.m`: environment subsystem, observation and reward subsystems and five RL Agent blocks. |
| `archive/reinforcemen_model.slx` | Earlier revision of the model with a simpler environment subsystem. |
| `archive/reinforcemen_model4.slx` | Later revision with a different reward and a fixed-step solver; `rl_model.m` does not reference it. |
| `data/traindataset.mat`, `data/traindataset_new.mat` | Logged goal and present positions of the five servos, replayed by the model. |
| `docs/model_overview.png` | Thumbnail of the model diagram. |

## How it works

### Agents (`rl_model.m`)

- Five agents are created, `agentA` for servo 1 (action `servo1`) and `agentB` to `agentE` for servos 2 to 5 (action `servo2to5`).
- Each agent receives a five-element observation and outputs one scalar servo command.
- Every agent is a DDPG agent with a deterministic actor and a Q-value critic built as `dlnetwork` objects.
- The actor ends in a `tanh` layer followed by a scaling layer that maps the output to the action range.
- Training uses `rlMultiAgentTrainingOptions` with agent 1 in its own group (decentralized) and agents 2 to 5 in one group (centralized).

| Item | Value |
| --- | --- |
| Sample time `Ts` / episode length `Tf` | 0.1 s / 17 s |
| Observation size per agent | 5 |
| Action range, servo 1 | -125 to 0 |
| Action range, servos 2 to 5 | 70 to 180 |
| Actor layers | 5 - 100 - 100 - 50 - 1, `tanh` activations |
| Actor output scaling, servo 1 | scale 62.5, bias -62.5 |
| Actor output scaling, servos 2 to 5 | scale 55, bias 125 |
| Critic state path | 5 - 100 (ReLU) - 100 |
| Critic action path | 1 - 100 |
| Critic common path | addition, sigmoid, 50, sigmoid, 1 |
| Critic / actor learning rate | 1e-3 / 1e-4 |
| Gradient threshold | 1 |
| Experience buffer length | 1e6 |
| Discount factor | 0.99 |
| Mini-batch size | 64 |
| Exploration noise variance / decay rate | 0.6 / 1e-5 |
| Maximum episodes | 5000 |
| Score averaging window | 400 |
| Stop criterion (average reward) | 1000 |
| Save criterion (episode reward) | 380 |

### Simulink model (`reinforcemen_model2.slx`)

- Two From Workspace blocks read `outCopy.goal_position` and `outCopy.present_position`, each with five channels.
- The five agent actions are multiplexed, delayed by one sample and fed to the environment subsystem `Subsystem3`; the action of agent 1 is negated first.
- `Subsystem3` uses the agents' servo commands when the logged position error is at or above a threshold and constant servo values otherwise.
- In the same condition the goal position is taken from the servo commands through one logistic function per servo, and otherwise from the logged goal position.
- The present load of each servo is a linear function of goal position minus present position, limited to a symmetric range.
- The present velocity is the time derivative of the scaled present position.
- The `observations` subsystem builds, for each servo, the vector of goal position, present position, present velocity, present load and servo command.
- The `reward1` subsystem outputs one reward and one termination flag per agent.

| Reward term (per servo) | Form |
| --- | --- |
| Position tracking | reciprocal of (absolute position error + block-default constant) |
| Velocity | reciprocal of (absolute velocity + block-default constant) when the absolute velocity is at most 3, otherwise 0.01 |
| Load change | reciprocal of (absolute change of the positive load between samples + block-default constant) |
| Overload penalty | -500 while the positive load exceeds 100 |
| Termination flag | set while the positive load exceeds 100 |

| Environment constant | Value |
| --- | --- |
| Position-error threshold for using agent commands | 15 |
| Constant servo values otherwise (servo 1 / servos 2 to 5) | 125 / 70 |
| Load limit of the linear load functions | -100 to 100 |
| Position scale before differentiation | 0.29 |
| Velocity divisor | 13.063 |
| Mirror offset for servos 4 and 5 | 1023 |
| Model stop time | 17 s |

### Archived revisions

- `archive/reinforcemen_model.slx` subtracts a servo-dependent offset from the logged goal position, has no position-error switch and uses a different overload threshold.
- `archive/reinforcemen_model4.slx` uses a reward made of negative position-error, velocity, load-direction, wrong-direction and servo-deviation terms, has no termination, and adds a manual switch for a ramp servo input.

## Requirements

- MATLAB with Simulink; the models were saved with release R2023b.
- Reinforcement Learning Toolbox (`rlNumericSpec`, `rlSimulinkEnv`, `rlDDPGAgent`, `rlMultiAgentTrainingOptions`, RL Agent block).
- Deep Learning Toolbox (`featureInputLayer`, `fullyConnectedLayer`, `layerGraph`, `dlnetwork`).
- A GPU usable by MATLAB, because actors and critics are created with `UseDevice="gpu"`.

## Running

- Place `rl_model.m` and `reinforcemen_model2.slx` in the same folder or on the MATLAB path.
- Load `data/traindataset.mat` or `data/traindataset_new.mat` so that the variable `outCopy` exists in the base workspace.
- Run `rl_model.m`; with `doTraining = true` it calls `train` on the five agents.

## Data

- `data/traindataset.mat` and `data/traindataset_new.mat` each hold `outCopy`, a log of a run of the robot hand hardware (March 2024).
- Each file holds one `Simulink.SimulationOutput` with the signals `goal_position`, `present_position`, `present_load` and `present_velocity`.
- Not included: trained agents and training logs, which were not in the source folder.

| Property of the log | Value |
| --- | --- |
| Channels per signal | 5 |
| Samples | 376 |
| Sample period | 0.05 s |
| Duration | 18.75 s |

## Notes

- This is research code kept as it was used in 2024 (file dates 2024-03); it has not been cleaned up or re-tested.
- The comment next to `obsInfo` in `rl_model.m` lists quantities of a different model; the observations actually wired in the Simulink model are the ones listed above.
- Several constants in the reward subsystem are left at the Simulink block defaults and are therefore not stored in the model file.
- The regression parameters inside the MATLAB Function blocks are fixed numbers; the script that fitted them is not part of this folder.
- Comments in the MATLAB Function blocks are in Korean.
