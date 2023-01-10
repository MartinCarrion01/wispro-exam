import { Center, Heading } from "@chakra-ui/react";

interface Props {
  text: String;
}

export default function SubTitle(props: Props) {
  return (
    <>
      <Center color="#222831" my={2}>
        <Heading as="h4" noOfLines={1}>
          {props.text}
        </Heading>
      </Center>
    </>
  );
}
