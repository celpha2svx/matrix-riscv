import matplotlib.pyplot as plt
import numpy as np

# Results from simulation
metrics = ['Instructions', 'Register Writes', 'Instr Memory\nTraffic (bytes)']
standard = [33, 32, 132]
mac      = [17, 16, 68]

x = np.arange(len(metrics))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))

bars1 = ax.bar(x - width/2, standard, width, label='Standard (mul+add)',
               color='#d9534f', edgecolor='black')
bars2 = ax.bar(x + width/2, mac,      width, label='Matrix-RISCV (mac)',
               color='#5cb85c', edgecolor='black')

# Add value labels on bars
for bar in bars1:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
            str(int(bar.get_height())), ha='center', va='bottom',
            fontweight='bold', fontsize=11)

for bar in bars2:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
            str(int(bar.get_height())), ha='center', va='bottom',
            fontweight='bold', fontsize=11)

# Add reduction % annotations
reductions = ['~48.5% reduction', '50% reduction', '~48.5% reduction']
for i, r in enumerate(reductions):
    ax.text(i, max(standard[i], mac[i]) + 6, r,
            ha='center', fontsize=9, color='#333333', style='italic')

ax.set_xlabel('Metric', fontsize=13)
ax.set_ylabel('Count', fontsize=13)
ax.set_title('Matrix-RISCV vs Standard RV32I\n4×4 Matrix MAC Benchmark (16 operations)',
             fontsize=14, fontweight='bold')
ax.set_xticks(x)
ax.set_xticklabels(metrics, fontsize=12)
ax.legend(fontsize=11)
ax.set_ylim(0, 160)
ax.grid(axis='y', linestyle='--', alpha=0.5)

plt.tight_layout()
plt.savefig('benchmark_chart.png', dpi=150, bbox_inches='tight')
print("Chart saved as benchmark_chart.png")
