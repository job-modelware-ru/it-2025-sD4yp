from graphviz import Digraph
import os

# Path to the script directory (PlayNext/src)
script_dir = os.path.dirname(os.path.abspath(__file__))

# Path to output directory (PlayNext/output)
project_root = os.path.dirname(script_dir)  # src -> PlayNext
output_dir = os.path.join(project_root, "output")

# Creating the output folder if it doesn't exist.
os.makedirs(output_dir, exist_ok=True)

# Create graph
dot = Digraph("Activity_PlayNext_RU", format="png")
dot.attr(rankdir="TB", fontsize="10")  # TB = top to bottom

# --- Styles ---
start_end = {"shape": "circle", "style": "filled", "color": "black", "fontcolor": "white"}
action = {"shape": "rect", "style": "rounded,filled", "color": "lightblue", "fontcolor": "black"}
gateway = {"shape": "diamond", "style": "filled", "color": "red", "fontcolor": "white"}

# --- Nodes ---
dot.node("start", "Начало", **start_end)
dot.node("prefs", "Ввод предпочтений", **action)
dot.node("analyze", "Анализ данных", **action)
dot.node("algo", "Алгоритм подбирает игры", **action)
dot.node("list", "Игрок получает список", **action)
dot.node("view", "Просмотр списка", **action)
dot.node("interested?", "Заинтересован?", **gateway)
dot.node("open", "Открыть игру / Купить / В желаемое", **action)
dot.node("feedback", "Оставить отзыв", **action)
dot.node("update", "Система обновляет профиль", **action)
dot.node("end", "Конец", **start_end)

# --- Edges ---
edge_attr = {"color": "black"}

dot.edge("start", "prefs", **edge_attr)
dot.edge("prefs", "analyze", **edge_attr)
dot.edge("analyze", "algo", **edge_attr)
dot.edge("algo", "list", **edge_attr)
dot.edge("list", "view", **edge_attr)
dot.edge("view", "interested?", **edge_attr)
dot.edge("interested?", "open", label="Да", **edge_attr)
dot.edge("interested?", "feedback", label="Нет", **edge_attr)
dot.edge("open", "end", **edge_attr)
dot.edge("feedback", "update", **edge_attr)
dot.edge("update", "end", **edge_attr)

# --- Save in output directory ---
output_path = os.path.join(output_dir, "PlayNext_Activity")
dot.render(output_path, cleanup=True)

print(f"Диаграмма сохранена как {output_path}.png")

