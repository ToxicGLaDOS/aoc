#include <stdio.h>
#include <stdlib.h>

#define LINE_LEN 16

struct board {
    int values[5][5];
    int marked[5][5];
};


unsigned int num_boards = 0;
struct board boards[100];
unsigned int sequence_length = 0;
int sequence[200];




void read_sequence(FILE *fp){
    char ch, current_num[3];
    int num_len = 0;
    while((ch = fgetc(fp)) != '\n') {
        if (ch == ','){
            // Set NULL terminator
            // Not sure if this is nesseccary :shrug:
            current_num[num_len] = 0;
            sequence[sequence_length] = atoi(current_num);
            sequence_length++;

            // Reset the number
            num_len = 0;
        }
        else {
            current_num[num_len] = ch;
            num_len++;
        }
    }
    current_num[num_len] = 0;
    sequence[sequence_length] = atoi(current_num);
    sequence_length++;

    //for (int i = 0; i < sequence_length; i ++) {
    //    printf("%d,", sequence[i]);
    //}
}

void read_board(FILE *fp) {

    unsigned int num_len = 0, num_count = 0;
    char line[LINE_LEN], number[3];

    for(int i = 0; i < 5; i++ ){
        fgets(line, LINE_LEN, fp);
        for(int j = 0; j < LINE_LEN; j ++){
            char ch = line[j];
            // If we find a space or the end of the string AND we've started to read a number
            // We need the num_len check because some lines are like " 6 34 13  5  9"; they start with a space or have multiple spaces
            if (ch == ' ' || ch == '\n' || ch == 0) {
                if (num_len > 0) {
                    number[num_len] = 0;
                    boards[num_boards].values[i][num_count] = atoi(number);
                    boards[num_boards].marked[i][num_count] = 0;
                    num_len = 0;
                    num_count++;
                }
            }
            else {
                number[num_len] = ch;
                num_len++;
            }
        }

        num_count = 0;
        num_len = 0;
    }

    num_boards++;
}

void read_boards(FILE *fp) {
    char ch;

    // fgetc consumes the newline
    while((ch = fgetc(fp)) != EOF) {
        read_board(fp);
    }
}

void mark_value(struct board *board, int n) {
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if(board->values[i][j] == n) {
                board->marked[i][j] = 1;
            }
        }
    }
}

int check_win(struct board *board) {
    for (int i = 0; i < 5; i++) {
        int horz_win = 1;
        int vert_win = 1;
        for (int j = 0; j < 5; j++) {
            if (!board->marked[i][j]) {
                horz_win = 0;
            }
            if (!board->marked[j][i]) {
                vert_win = 0;
            }
        }

        if (horz_win || vert_win) {
            return 1;
        }
    }

    return 0;
}

int sum_unmarked(struct board *board) {
    int sum = 0;

    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if (!board->marked[i][j]) {
                sum += board->values[i][j];
            }
        }
    }

    return sum;
}

void print_board(int n) {
    //struct board board = boards[n];

    for(int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            printf("%d,", boards[n].values[i][j]);
        }
        printf("\n");
    }

    for(int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if (boards[n].marked[i][j]) {
                printf("1,");
            }
            else {
                printf("0,");
            }
        }
        printf("\n");
    }
    printf("\n");
}

int main(){
    char ch, file_name[25] = "../input/day4.txt";
    FILE *fp;

    fp = fopen(file_name, "r"); // read mode

    if (fp == NULL)
    {
        perror("Error while opening the file.\n");
        exit(EXIT_FAILURE);
    }

    read_sequence(fp);

    read_boards(fp);

    for (int i = 0; i < sequence_length; i++ ) {
        int value = sequence[i];
        for (int j = 0; j < num_boards; j++ ) {
            mark_value(&boards[j], value);
            if (check_win(&boards[j])) {
                print_board(j);
                int sum = sum_unmarked(&boards[j]);
                printf("Unmarked sum: %d, Last call: %d, Product: %d", sum, value, sum*value);
                return 0;
            }
        }
    }

    fclose(fp);
    return 0;
}
