#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "rtp.h"

/* GIVEN Function:
 * Handles creating the client's socket and determining the correct
 * information to communicate to the remote server
 */
CONN_INFO* setup_socket(char* ip, char* port){
    struct addrinfo *connections, *conn = NULL;
    struct addrinfo info;
    memset(&info, 0, sizeof(struct addrinfo));
    int sock = 0;
    
    info.ai_family = AF_INET;
    info.ai_socktype = SOCK_DGRAM;
    info.ai_protocol = IPPROTO_UDP;
    getaddrinfo(ip, port, &info, &connections);
    
    /*for loop to determine corr addr info*/
    for(conn = connections; conn != NULL; conn = conn->ai_next){
        sock = socket(conn->ai_family, conn->ai_socktype, conn->ai_protocol);
        if(sock <0){
            if(DEBUG)
                perror("Failed to create socket\n");
            continue;
        }
        if(DEBUG)
            printf("Created a socket to use.\n");
        break;
    }
    if(conn == NULL){
        perror("Failed to find and bind a socket\n");
        return NULL;
    }
    CONN_INFO* conn_info = malloc(sizeof(CONN_INFO));
    conn_info->socket = sock;
    conn_info->remote_addr = conn->ai_addr;
    conn_info->addrlen = conn->ai_addrlen;
    return conn_info;
}

void shutdown_socket(CONN_INFO *connection){
    if(connection)
        close(connection->socket);
}

/*
 * ===========================================================================
 *
 *			STUDENT CODE STARTS HERE. PLEASE COMPLETE ALL FIXMES
 *
 * ===========================================================================
 */


/*
 *  Returns a number computed based on the data in the buffer.
 */
static int checksum(char *buffer, int length){
    
    /*  ----  FIXME  ----
     *
     *  The goal is to return a number that is determined by the contents
     *  of the buffer passed in as a parameter.  There a multitude of ways
     *  to implement this function.  For simplicity, simply sum the ascii
     *  values of all the characters in the buffer, and return the total.
     */
    int total = 0;
    for (int i = 0; i < length; i++) {
        total ^= (char)buffer[i];
    }
    return total;
}

/*
 *  Converts the given buffer into an array of PACKETs and returns
 *  the array.  The value of (*count) should be updated so that it
 *  contains the length of the array created.
 */
static PACKET* packetize(char *buffer, int length, int *count){
    
    /*  ----  FIXME  ----
     *  The goal is to turn the buffer into an array of packets.
     *  You should allocate the space for an array of packets and
     *  return a pointer to the first element in that array.  Each
     *  packet's type should be set to DATA except the last, as it
     *  should be LAST_DATA type. The integer pointed to by 'count'
     *  should be updated to indicate the number of packets in the
     *  array.
     */
    
    // Length of packetArr
    int packetArrLen = (length + MAX_PAYLOAD_LENGTH - 1) / MAX_PAYLOAD_LENGTH;
    *count = packetArrLen;
    PACKET* packetArr = calloc(packetArrLen, sizeof(PACKET));
    int currPosInPayload = 0;
    for (int i = 0; i < length; i++) {
        // Get current packet
        int currPacket = i / MAX_PAYLOAD_LENGTH;
        // Get payload within the packet
        currPosInPayload = i % MAX_PAYLOAD_LENGTH;
        packetArr[currPacket].payload[currPosInPayload] = buffer[i];
        
        // 2 situations for packet type/payload_length: Reaches last packet or reaches MAX_PAYLOAD_LENGTH
        // Set MAX_PAYLOAD_LENGTH to type data
        if (i == (length - 1)) {
            packetArr[currPacket].type = LAST_DATA;
            packetArr[currPacket].payload_length = currPosInPayload + 1;
            packetArr[currPacket].checksum = checksum(packetArr[currPacket].payload, currPosInPayload + 1);
        }
        else if (currPosInPayload == MAX_PAYLOAD_LENGTH - 1) {
            packetArr[currPacket].type = DATA;
            packetArr[currPacket].payload_length = MAX_PAYLOAD_LENGTH;
            packetArr[currPacket].checksum = checksum(packetArr[currPacket].payload, MAX_PAYLOAD_LENGTH);
        }
    }
    return packetArr;
}

/*
 * Send a message via RTP using the connection information
 * given on UDP socket functions sendto() and recvfrom()
 */
int rtp_send_message(CONN_INFO *connection, MESSAGE*msg){
    /* ---- FIXME ----
     * The goal of this function is to turn the message buffer
     * into packets and then, using stop-n-wait RTP protocol,
     * send the packets and re-send if the response is a NACK.
     * If the response is an ACK, then you may send the next one
     */
    int count = 0;
    PACKET* packets = packetize(msg->buffer, msg->length, &count);
    for (int i = 0; i < count; i++) {
        sendto(connection->socket, (packets + i), sizeof(PACKET), 0, connection->remote_addr, connection->addrlen);
        int ack = 0;
        PACKET *response = (PACKET*)malloc(sizeof(PACKET));
        // Wait until an ACK is received, else resend the packet (Stop & Wait Implementation)
        while (ack == 0) {
            // Receive packet from connection
            recvfrom(connection->socket, response, sizeof(PACKET), 0, connection->remote_addr, &connection->addrlen);
            // Positive ACK packet
            if (response->type == ACK) {
                ack = 1;
            }
            // Negative ACK packet
            else if (response->type == NACK) {
                ack = 2;
                i -= 1;
            }
        }
    }
    return 1;
}

/*
 * Receive a message via RTP using the connection information
 * given on UDP socket functions sendto() and recvfrom()
 */
MESSAGE* rtp_receive_message(CONN_INFO *connection){
    /* ---- FIXME ----
     * The goal of this function is to handle
     * receiving a message from the remote server using
     * recvfrom and the connection info given. You must
     * dynamically resize a buffer as you receive a packet
     * and only add it to the message if the data is considered
     * valid. The function should return the full message, so it
     * must continue receiving packets and sending response
     * ACK/NACK packets until a LAST_DATA packet is successfully
     * received.
     */
    MESSAGE* message = (MESSAGE*)malloc(sizeof(MESSAGE));
    
    PACKET *feedback = (PACKET*)malloc(sizeof(PACKET));
    int last_data = 0;
    
    while (last_data == 0) {
        recvfrom(connection->socket, feedback, sizeof(PACKET), 0, connection->remote_addr, &connection->addrlen);
        // Send ACK/NACK Packet
        if (checksum(feedback->payload, feedback->payload_length) == feedback->checksum) {
            PACKET *ackPack = (PACKET*)malloc(sizeof(PACKET));
            ackPack->type = ACK;
            sendto(connection->socket, ackPack, sizeof(PACKET), 0, connection->remote_addr, connection->addrlen);
            if (feedback->type == LAST_DATA) {
                last_data = 1;
            }
            if (message->length == 0) {
                message->buffer = (char*) malloc(sizeof(char) * feedback->payload_length);
            } else {
                message->buffer = (char*) realloc(message->buffer, message->length + feedback->payload_length);
            }
            for (int i = 0; i < feedback->payload_length; i++) {
                message->buffer[i + message->length] = feedback->payload[i];
            }
            message->length = message->length + feedback->payload_length;
        } else {
            PACKET *ackPack = (PACKET*)malloc(sizeof(PACKET));
            ackPack->type = NACK;
            sendto(connection->socket, ackPack, sizeof(PACKET), 0, connection->remote_addr, connection->addrlen);
        }
    }
    message->buffer[message->length] = '\0';
    message->length = message->length + 1;
    return message;
}
