import { Flex, Stack, Text } from "@chakra-ui/react";

export default function Home() {
  return (
    <>
      <Flex direction="column" align="center" justify="center" my="50">
        <Stack spacing={3}>
          <Text fontSize="7xl" textAlign={"center"}>
            ¡Bienvenidos a Wispro Client!
          </Text>
        </Stack>
      </Flex>
    </>
  );
}
