def count_directions(file_path):
    try:
        with open(file_path, 'r') as file:
            content = file.read()
        
        counts = {
            'R': content.count('R'),
            'U': content.count('U'),
            'L': content.count('L'),
            'D': content.count('D')
        }
        
        return counts
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None

if __name__ == "__main__":
    file_path = input("Enter the file path: ")
    result = count_directions("./moves.txt")
    if result:
        for direction, count in result.items():
            print(f"{direction}: {count}")