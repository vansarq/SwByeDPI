#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/time.h>

#include "byedpi/error.h"
#include "ciadpi_bridge.h"

extern int server_fd;

struct params default_params = {
        .await_int = 10,
        .ipv6 = 1,
        .resolve = 1,
        .udp = 1,
        .max_open = 512,
        .bfsize = 16384,
        .baddr = {
            .in6 = { .sin6_family = AF_INET6 }
        },
        .laddr = {
            .in = { .sin_family = AF_INET }
        },
        .debug = 0
};

void reset_params(void) {
    clear_params();
    params = default_params;
}

int start_proxy(int argc, char **argv) {
    if (server_fd > 0) {
        LOG(LOG_S, "proxy already running");
        return -1;
    }
    LOG(LOG_S, "starting proxy with %d args", argc);
    
    optind = 1;

    int result = ciadpi_main(argc, argv);

    LOG(LOG_S, "proxy return code %d", result);

    return result;
}

int proxy_running(void) {
    if (server_fd > 0) {
        return 1;
    }
    return 0;
}

int stop_proxy(void) {
    LOG(LOG_S, "send shutdown to proxy");
    if (server_fd <= 0) {
        LOG(LOG_S, "proxy is not running");
        return -1;
    }
    
    struct sockaddr_in addr;
    socklen_t addr_len = sizeof(addr);
    getsockname(server_fd, (struct sockaddr *)&addr, &addr_len);
    int port = ntohs(addr.sin_port);
    
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        LOG(LOG_S, "Unable to create socket for stock closing");
        return -1;
    }

    struct timeval timeout;
    timeout.tv_sec = 0;
    timeout.tv_usec = 500000;
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(port);
    inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
    
    // Connect to SOCKS server
    // Sending the empty or random data makes no sense - accept() will drop it and continue wait
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) != 0) {
        LOG(LOG_S, "Unable to connect via socket");
        close(sock);
        return -1;
    }
    
    // Poison for descriptor -> shutdown without close -> replace by /dev/null at server_fd
    shutdown(server_fd, SHUT_RDWR);
    int dummy = open("/dev/null", O_RDONLY);
    if (dummy >= 0) {
        dup2(dummy, server_fd);
        close(dummy);
    }
    // Send invalid message for socket (poll event)
    // The first byte shouldn't be 0x04 or 0x05 (SOCKS 4/5) -> leads to race condition (proxy.c -> on_request)
    unsigned char socks5_hello[] = {0xff, 0x0, 0x1};
    send(sock, socks5_hello, sizeof(socks5_hello), 0);
    close(sock);
    // Wait for proxy core processing
    usleep(50000);
    // Close server_fd (risky for EXC_BAD_ACCESS caused by closed fd)
    if (server_fd > 0) {
        close(server_fd);
        server_fd = -1;
    }
    
    return 0;
}

int stop_proxy_tun(void) {
    if (server_fd <= 0) {
        LOG(LOG_S, "proxy is not running");
        return -1;
    }
    shutdown(server_fd, SHUT_RDWR);
    close(server_fd);
    server_fd = -1;
    return 0;
}
