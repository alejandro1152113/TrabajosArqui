from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator
from qiskit_aer.noise import NoiseModel, depolarizing_error
from qiskit.visualization import plot_histogram
import matplotlib.pyplot as plt

def build_grover_circuit(target="11"):
    qc = QuantumCircuit(2, 2)
    qc.h([0, 1])
    for qubit, bit in zip([1, 0], target):
        if bit == "0":
            qc.x(qubit)
    qc.cz(0, 1)
    for qubit, bit in zip([1, 0], target):
        if bit == "0":
            qc.x(qubit)
    qc.h([0, 1])
    qc.x([0, 1])
    qc.cz(0, 1)
    qc.x([0, 1])
    qc.h([0, 1])
    qc.measure([0, 1], [0, 1])
    return qc

def build_noise_model(p1q=0.001, p2q=0.01):
    noise_model = NoiseModel()
    noise_model.add_all_qubit_quantum_error(depolarizing_error(p1q, 1), ["h", "x"])
    noise_model.add_all_qubit_quantum_error(depolarizing_error(p2q, 2), ["cz"])
    return noise_model

def grover_noise_experiment(target="11", shots=1024):
    qc = build_grover_circuit(target)
    counts_ideal = AerSimulator().run(qc, shots=shots).result().get_counts()
    counts_noisy = AerSimulator(noise_model=build_noise_model()).run(qc, shots=shots).result().get_counts()
    p_ideal = counts_ideal.get(target, 0) / shots
    p_noisy = counts_noisy.get(target, 0) / shots
    print(f"Grover |{target}> sin ruido: {p_ideal*100:.1f}%")
    print(f"Grover |{target}> con ruido: {p_noisy*100:.1f}%")
    print(f"Degradacion: {(p_ideal-p_noisy)*100:.1f} puntos porcentuales")
    fig, axs = plt.subplots(1, 2, figsize=(10, 4))
    plot_histogram(counts_ideal, ax=axs[0], title="Sin ruido")
    plot_histogram(counts_noisy, ax=axs[1], title="Con ruido (despolarizante)")
    fig.tight_layout()
    fig.savefig("capturas/grover_noise_comparison.png", dpi=150)
    return p_ideal, p_noisy

if __name__ == "__main__":
    grover_noise_experiment()
