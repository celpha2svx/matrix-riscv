import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

# Manually extracted from simulation output - cycle by cycle
cycles = list(range(1, 18))

# MAC_Enable signal (1 for cycles 1-16, 0 for cycle 17)
mac_enable = [1]*16 + [0]

# RegWrite signal
reg_write = [1]*16 + [0]

# MACResult values (decimal) from simulation
mac_results = [
    0x42, 0x2d6, 0x1f32, 0x15726,
    0xebea2, 0xa230f6, 0x6f81a92, 0x4ca92446,
    0x4b448f02, 0x3bf22516, 0x936797f2, 0x55738766,
    0xabf6d162, 0x639aff36, 0x47a8f752, 0x1442a086,
    0x0
]

# Normalize MACResult for display (0 to 1 range)
max_val = max(mac_results[:-1])
mac_norm = [v / max_val for v in mac_results]

fig, axes = plt.subplots(3, 1, figsize=(14, 7), sharex=True)
fig.suptitle('Matrix-RISCV Simulation Waveform\n16-MAC Benchmark (4×4 Matrix)',
             fontsize=13, fontweight='bold')

# ── Plot 1: CLK-style MAC_Enable ──
ax1 = axes[0]
ax1.step(cycles, mac_enable, where='mid', color='#2196F3', linewidth=2)
ax1.fill_between(cycles, mac_enable, step='mid', alpha=0.2, color='#2196F3')
ax1.set_ylabel('MAC_Enable', fontsize=10)
ax1.set_ylim(-0.2, 1.5)
ax1.set_yticks([0, 1])
ax1.grid(axis='x', linestyle='--', alpha=0.4)
ax1.axvline(x=16.5, color='red', linestyle='--', alpha=0.6, label='store instr')
ax1.legend(fontsize=8, loc='upper right')

# ── Plot 2: RegWrite ──
ax2 = axes[1]
ax2.step(cycles, reg_write, where='mid', color='#4CAF50', linewidth=2)
ax2.fill_between(cycles, reg_write, step='mid', alpha=0.2, color='#4CAF50')
ax2.set_ylabel('RegWrite', fontsize=10)
ax2.set_ylim(-0.2, 1.5)
ax2.set_yticks([0, 1])
ax2.grid(axis='x', linestyle='--', alpha=0.4)
ax2.axvline(x=16.5, color='red', linestyle='--', alpha=0.6)

# ── Plot 3: MACResult (normalized) ──
ax3 = axes[2]
ax3.plot(cycles, mac_norm, color='#FF9800', linewidth=2, marker='o',
         markersize=4, label='MACResult (normalised)')
ax3.fill_between(cycles, mac_norm, alpha=0.15, color='#FF9800')
ax3.set_ylabel('MACResult\n(normalised)', fontsize=10)
ax3.set_xlabel('Clock Cycle', fontsize=11)
ax3.set_ylim(-0.05, 1.15)
ax3.grid(axis='x', linestyle='--', alpha=0.4)
ax3.axvline(x=16.5, color='red', linestyle='--', alpha=0.6)
ax3.legend(fontsize=8, loc='upper left')

# Annotate key cycles
ax3.annotate('Cycle 1\n0x42', xy=(1, mac_norm[0]),
             xytext=(2.5, 0.15), fontsize=7,
             arrowprops=dict(arrowstyle='->', color='gray'))
ax3.annotate('Cycle 16\n0x1442a086', xy=(16, mac_norm[15]),
             xytext=(13, 0.85), fontsize=7,
             arrowprops=dict(arrowstyle='->', color='gray'))

plt.xticks(cycles)
plt.tight_layout()
plt.savefig('waveform.png', dpi=150, bbox_inches='tight')
print("Waveform saved as waveform.png")
